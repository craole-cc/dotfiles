_: {
  settings = {
    #~@ Activity bar & side bar
    #> Where the Activity Bar sits relative to the side bars.
    #?  - default: Side of the Primary Side Bar, above the Secondary.
    #?  - top | bottom | hidden
    #! overridden (default: "default")
    "workbench.activityBar.location" = "default";
    #> Auto-hide the Activity Bar when only one view container is shown.
    "workbench.activityBar.autoHide" = false;
    #> Compact Activity Bar layout (smaller icons, narrower).
    "workbench.activityBar.compact" = false;
    #> Click behaviour on Activity Bar icons.
    #?  - toggle | focus
    "workbench.activityBar.iconClickBehavior" = "toggle";
    #> Primary side bar location (`left` | `right`).
    #! overridden (default: "left")
    "workbench.sideBar.location" = "right";

    #~@ Secondary side bar
    #> Default visibility of the secondary side bar in new windows.
    #?  - hidden | visibleInWorkspace | visible
    #?  - maximizedInWorkspace | maximized
    "workbench.secondarySideBar.defaultVisibility" = "visibleInWorkspace";
    #> Force secondary side bar maximized on startup / no open editors.
    "workbench.secondarySideBar.forceMaximized" = false;

    #~@ Panel
    #> Default location of the panel (terminal, output, problems, …).
    #?  - bottom | top | left | right
    #! overridden (default: "bottom")
    "workbench.panel.defaultLocation" = "bottom";
    #> Whether the panel opens maximized.
    #?  - always | never | preserve
    "workbench.panel.opensMaximized" = "preserve";
    #> Show labels (not icons) for panel title actions.
    "workbench.panel.showLabels" = true;

    #~@ Status Bar
    #! overridden (default: true)
    "workbench.statusBar.visible" = true;

    #~@ Breadcrumbs
    #! overridden (default: false)
    "breadcrumbs.enabled" = true;
    #> How file paths appear in breadcrumbs.
    #?  - on | off | last
    "breadcrumbs.filePath" = "on";
    #> Show icons in breadcrumbs.
    "breadcrumbs.icons" = true;
    #> Show editor-type dropdown when multiple editors can open the file.
    "breadcrumbs.showEditorType" = true;
    #> Symbol path in breadcrumbs (`on` | `off` | `last`).
    "breadcrumbs.symbolPath" = "on";
    #> Symbol path separator when copying breadcrumb paths.
    "breadcrumbs.symbolPathSeparator" = ".";
    #> Symbol outline sort order.
    #?  - position | name | type
    "breadcrumbs.symbolSortOrder" = "position";

    #~@ Editor tabs
    #> What to show when no editor is open.
    #?  - none | welcomePage | readme | newUntitledFile
    #?  - welcomePageInEmptyWorkbench | terminal
    #! overridden (default: "welcomePage")
    "workbench.startupEditor" = "none";
    #> How editor tabs are shown.
    #?  - multiple | single | none
    #! overridden (default: "multiple")
    "workbench.editor.showTabs" = "multiple";
    #> Reveal an already-open editor instead of opening another.
    #! overridden (default: false)
    "workbench.editor.revealIfOpen" = true;
    #> Show hint text when the editor is empty.
    #?  - hidden | text | watermark
    #! overridden (default: "text")
    "workbench.editor.empty.hint" = "hidden";
    #> Where new editors open.
    #?  - left | right | first | last
    "workbench.editor.openPositioning" = "right";
    #> Direction for split-side editors.
    #?  - right | down
    "workbench.editor.openSideBySideDirection" = "right";
    #> Enable preview editors (italic tab; replaced on next open).
    "workbench.editor.enablePreview" = true;
    #> Preview editors opened from Quick Open.
    "workbench.editor.enablePreviewFromQuickOpen" = false;
    #> Preview editors opened via code navigation.
    "workbench.editor.enablePreviewFromCodeNavigation" = false;
    #> Whether to use modal editors (`off` | `some` | `all`).
    #! overridden (default: "some")
    "workbench.editor.useModal" = "off";
    #> Pinned tab size (`normal` | `compact` | `shrink`).
    "workbench.editor.pinnedTabSizing" = "normal";
    #> Pinned tabs on a separate row.
    "workbench.editor.pinnedTabsOnSeparateRow" = false;
    #> Size of editor tabs (`fit` | `shrink` | `fixed`).
    "workbench.editor.tabSizing" = "fit";
    #> Max width for `tabSizing = "fixed"`.
    "workbench.editor.tabSizingFixedMaxWidth" = 160;
    #> Min width for `tabSizing = "fixed"`.
    "workbench.editor.tabSizingFixedMinWidth" = 50;
    #> Show close button on tabs.
    "workbench.editor.tabActionCloseVisibility" = true;
    #> Show unpin button on tabs.
    "workbench.editor.tabActionUnpinVisibility" = true;
    #> Tab action button position (`left` | `right`).
    "workbench.editor.tabActionLocation" = "right";
    #> Wrap tabs to multiple lines instead of a scrollbar.
    "workbench.editor.wrapTabs" = false;
    #> Scroll over tabs switches editors.
    "workbench.editor.scrollToSwitchTabs" = false;
    #> What clicking `×` closes.
    #?  - keyboardAndMouse | keyboard | mouse | never
    "workbench.editor.preventPinnedEditorClose" = "keyboardAndMouse";
    #> Show tab icons (requires an icon theme).
    "workbench.editor.showIcons" = true;
    #> Show tab index number.
    "workbench.editor.showTabIndex" = false;
    #> Highlight tabs with unsaved changes (border on top).
    "workbench.editor.highlightModifiedTabs" = false;
    #> Label format for editor tabs.
    #?  - default | short | medium | long
    "workbench.editor.labelFormat" = "default";
    #> Direction of split editors within a group.
    #?  - vertical | horizontal
    "workbench.editor.splitInGroupLayout" = "horizontal";
    #> Split sizing (`auto` | `distribute` | `split`).
    "workbench.editor.splitSizing" = "auto";
    #> Restore last editor view state on reopen.
    "workbench.editor.restoreViewState" = true;
    #> Restore editors on startup.
    "workbench.editor.restoreEditors" = true;
    #> Focus most-recently used editor after close.
    "workbench.editor.focusRecentEditorAfterClose" = true;

    #~@ Editor Groups
    #> Close empty editor groups.
    "workbench.editor.closeEmptyGroups" = true;
    #> Limit open editors.
    "workbench.editor.limit.enabled" = false;
    #> Limit per editor group (vs across all).
    "workbench.editor.limit.perEditorGroup" = false;
    #> Limit value.
    "workbench.editor.limit.value" = 10;

    #~@ Command Palette & Quick Open
    #> Preserve typed input in the command palette.
    #! overridden (default: false)
    "workbench.commandPalette.preserveInput" = true;
    #> Preserve typed input in Quick Open.
    #! overridden (default: false)
    "workbench.quickOpen.preserveInput" = true;
    #> Close Quick Open when it loses focus.
    "workbench.quickOpen.closeOnFocusLost" = true;
    #> Command palette history size (0 = disabled).
    "workbench.commandPalette.history" = 50;
    #> Show natural-language search in the command palette.
    "workbench.commandPalette.experimental.enableNaturalLanguageSearch" = true;
    #> Show "Ask in Chat" in the command palette.
    "workbench.commandPalette.showAskInChat" = true;

    #~@ Trees & Lists
    #> Sticky scroll in trees.
    #! overridden (default: true)
    "workbench.tree.enableStickyScroll" = false;
    #> Tree indent (px).
    "workbench.tree.indent" = 8;
    #> Indent guides (`none` | `onHover` | `always`).
    "workbench.tree.renderIndentGuides" = "onHover";
    #> Sticky tree item count.
    "workbench.tree.stickyScrollMaxItemCount" = 7;
    #> Expand folders on single or double click.
    #?  - singleClick | doubleClick
    "workbench.tree.expandMode" = "singleClick";
    #> Keyboard navigation for lists/trees.
    #?  - simple | highlight | filter
    "workbench.list.keyboardNavigation" = "highlight";
    #> Default find mode for lists/trees.
    #?  - highlight | filter
    "workbench.list.defaultFindMode" = "highlight";
    #> Default find match type for lists/trees.
    #?  - fuzzy | contiguous
    "workbench.list.defaultFindMatchType" = "fuzzy";
    #> Multi-select modifier for lists/trees.
    #?  - ctrlCmd | alt
    "workbench.list.multiSelectModifier" = "ctrlCmd";
    #> Open mode for lists/trees (`singleClick` | `doubleClick`).
    "workbench.list.openMode" = "singleClick";
    #> Smooth scrolling in lists/trees.
    "workbench.list.smoothScrolling" = false;
    #> Horizontal scrolling in lists/trees.
    "workbench.list.horizontalScrolling" = false;

    #~@ Window
    #> Menu bar style.
    #?  - classic | visible | toggle | hidden | compact
    #! overridden (default: "classic")
    "window.menuBarVisibility" = "toggle";
    #> Custom title bar style (`native` | `custom`).
    #! overridden (default: "native")
    "window.titleBarStyle" = "native";
    #> Custom title bar visibility.
    #?  - auto | windowed | never
    #! overridden (default: "auto")
    "window.customTitleBarVisibility" = "auto";
    #> Alt-key focuses the menu bar.
    #! overridden (default: true)
    "window.customMenuBarAltFocus" = true;
    #> Restore to fullscreen if exited in fullscreen.
    #! overridden (default: false)
    "window.restoreFullscreen" = true;
    #> Zoom per window vs global.
    #! overridden (default: false)
    "window.zoomPerWindow" = true;
    #> Command centre in the title bar.
    "window.commandCenter" = true;
    #> Menu style (`custom` | `native` | `inherit`).
    "window.menuStyle" = "inherit";
    #> Window controls style (`native` | `custom` | `hidden`).
    "window.controlsStyle" = "native";
    #> Dialog style (`native` | `custom`).
    "window.dialogStyle" = "native";
    #> Double-click title bar icon to close.
    "window.doubleClickIconToClose" = false;
    #> Open files in a new window (`on` | `off` | `default`).
    "window.openFilesInNewWindow" = "off";
    #> Open folders in a new window (`on` | `off` | `default`).
    "window.openFoldersInNewWindow" = "default";
    #> New window dimensions.
    #?  - default | inherit | offset | maximized | fullscreen
    "window.newWindowDimensions" = "default";

    #~@ Layout density
    #> Editor tab height (`default` | `compact`).
    "window.density.editorTabHeight" = "default";

    #~@ Zen mode
    #> Centre layout in Zen mode.
    "zenMode.centerLayout" = true;
    #> Full screen in Zen mode.
    "zenMode.fullScreen" = true;
    #> Hide Activity Bar in Zen mode.
    "zenMode.hideActivityBar" = true;
    #> Hide line numbers in Zen mode.
    "zenMode.hideLineNumbers" = true;
    #> Hide status bar in Zen mode.
    "zenMode.hideStatusBar" = true;
    #> Restore Zen mode on restart.
    "zenMode.restore" = true;
    #> Show tabs in Zen mode (`multiple` | `single` | `none`).
    "zenMode.showTabs" = "multiple";
    #> Silence non-error notifications in Zen mode.
    "zenMode.silentNotifications" = true;

    #~@ Misc
    #> Experimental: share action in the command centre.
    #! overridden (default: false)
    "workbench.experimental.share.enabled" = true;
    #> Ignore extension recommendations.
    #! overridden (default: false)
    "extensions.ignoreRecommendations" = true;
  };
}
