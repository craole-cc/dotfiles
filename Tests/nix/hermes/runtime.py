"""Exercise the flake's settings with its Hermes consumers in temporary homes."""

import argparse
import copy
import importlib
import json
import os
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch


class SettingsContract(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="hermes-settings-case-")
        self.addCleanup(temporary.cleanup)
        self.home = Path(temporary.name) / "hermes"
        self.home.mkdir()
        self.native = Path(temporary.name) / "native"
        self.native.mkdir()
        os.environ["HOME"] = str(self.native)
        os.environ["HERMES_HOME"] = str(self.home)
        self.settings = copy.deepcopy(FIXTURE["settings"])
        self.write_settings()
        for name, profile in FIXTURE["profiles"].items():
            directory = self.home / "profiles" / name
            directory.mkdir(parents=True)
            (directory / "config.yaml").write_text(json.dumps(profile["settings"]))
            (directory / "profile.yaml").write_text(json.dumps(profile["metadata"]))

    def write_settings(self):
        (self.home / "config.yaml").write_text(json.dumps(self.settings))

    def test_imports_use_selected_flake_source(self):
        for module in MODULES.values():
            self.assertTrue(Path(module.__file__).is_relative_to(SOURCE))

    def test_real_gateway_loader_reads_routes_and_multiplexing(self):
        config = MODULES["gateway.config"].load_gateway_config()
        self.assertIs(config.multiplex_profiles, True)
        self.assertEqual(len(config.profile_routes), 1)
        self.assertEqual(config.profile_routes[0].profile, "intake")
        self.assertTrue(config.profile_routes[0].matches("telegram", chat_id="123"))
        self.assertFalse(config.profile_routes[0].matches("telegram", chat_id="456"))

    def test_declared_routes_override_stale_nested_settings(self):
        self.settings["gateway"] = {
            "multiplex_profiles": False,
            "profile_routes": [{"platform": "telegram", "profile": "reviewer"}],
        }
        self.write_settings()
        config = MODULES["gateway.config"].load_gateway_config()
        self.assertIs(config.multiplex_profiles, True)
        self.assertEqual(config.profile_routes[0].profile, "intake")

    def test_shared_bot_route_does_not_capture_a_different_bot(self):
        route = MODULES["gateway.config"].load_gateway_config().profile_routes[0]
        self.assertFalse(route.matches("telegram", chat_id="123", adapter_profile="reviewer"))

    def dispatcher_settings(self, settings):
        return MODULES["gateway.kanban_watchers_dispatcher"]._resolve_dispatcher_settings(
            settings["kanban"], MODULES["hermes_cli.kanban_db"]
        )

    def test_dispatcher_consumes_limits_and_assignee(self):
        resolved = self.dispatcher_settings(self.settings)
        self.assertEqual(resolved.max_in_progress, 1)
        self.assertEqual(resolved.max_in_progress_per_profile, 1)
        self.assertEqual(resolved.default_assignee, "planner")

    def test_default_assignee_is_not_silently_disabled(self):
        resolved = self.dispatcher_settings(FIXTURE["defaultSettings"])
        self.assertEqual(resolved.default_assignee, "default")

    def allowlist(self):
        return MODULES["hermes_cli.kanban_db_dispatch"]._dispatch_profile_allowlist(
            MODULES["hermes_cli.profiles"].normalize_profile_name
        )

    def test_dispatcher_reads_worker_allowlist(self):
        self.assertEqual(self.allowlist(), frozenset({"planner", "reviewer"}))

    def test_empty_worker_list_pauses_claims(self):
        self.settings["kanban"]["dispatch_profiles"] = []
        self.write_settings()
        self.assertEqual(self.allowlist(), frozenset())

    def test_profile_metadata_is_recognised_by_hermes(self):
        directory = self.home / "profiles" / "intake"
        metadata = MODULES["hermes_cli.profiles"].read_profile_meta(directory)
        self.assertEqual(metadata["bot_title"], "Reception")
        self.assertTrue(MODULES["tools.bot_mode_probe"]._is_bot_managed(directory))

    def test_null_bot_metadata_clears_managed_marker(self):
        directory = self.home / "profiles" / "intake"
        (directory / "profile.yaml").write_text(json.dumps({"ui_meta": {"hermes-bots": None}}))
        self.assertFalse(MODULES["tools.bot_mode_probe"]._is_bot_managed(directory))

    def test_decomposer_roster_is_wider_than_dispatch_allowlist(self):
        # This is an upstream boundary: dispatch_profiles does not filter planning.
        roster, names = MODULES["hermes_cli.kanban_decompose"]._build_roster()
        self.assertIn("intake", names)
        self.assertIn("intake", {entry["name"] for entry in roster})
        self.assertNotIn("intake", self.allowlist())


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, required=True)
    parser.add_argument("--fixture", type=Path, required=True)
    arguments = parser.parse_args()
    SOURCE = arguments.source.resolve()
    FIXTURE = json.loads(arguments.fixture.read_text())
    sys.dont_write_bytecode = True
    sys.path.insert(0, str(SOURCE))
    inherited_path = os.environ.get("PATH", "")
    with tempfile.TemporaryDirectory(prefix="hermes-settings-imports-") as directory:
        os.environ.clear()
        os.environ.update(HOME=directory, HERMES_HOME=directory + "/hermes", PATH=inherited_path)
        with patch("socket.socket.connect", side_effect=AssertionError("Network calls are forbidden in these checks")):
            MODULES = {
                name: importlib.import_module(name)
                for name in (
                    "gateway.config",
                    "gateway.kanban_watchers_dispatcher",
                    "hermes_cli.kanban_db",
                    "hermes_cli.kanban_db_dispatch",
                    "hermes_cli.kanban_decompose",
                    "hermes_cli.profiles",
                    "tools.bot_mode_probe",
                )
            }
            unittest.main(argv=[sys.argv[0]], verbosity=2)
