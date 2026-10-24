_: {
    enable = false;
  extensions = [
    #? Prose grammar + style linter (Harper `harper-ls`)
    "elijah-potter.harper"
  ];

  settings = {
    #~@ Top-level Settings
    #> Stable code action positions: puts "always available" actions
    #> (e.g. add-to-dictionary) first.
    "harper.codeActions.ForceStable" = false;

    #> Diagnostic severity in the editor.
    #? - error | warning | information | hint
    "harper.diagnosticSeverity" = "information";

    #> English dialect. Drives which spelling is considered correct.
    #? - American | British | Australian | Canadian
    "harper.dialect" = "British"; #! overridden (default: "American")

    #> Globs to skip. Files matching any are not linted.
    "harper.excludePatterns" = [];

    #> Path to a file dictionary directory. Empty = none.
    "harper.fileDictPath" = "";

    #> Only lint English text in mixed-language documents.
    "harper.isolateEnglish" = false;

    #> Skip linting link titles in Markdown.
    "harper.markdown.IgnoreLinkTitle" = false;

    #> Maximum file size (bytes) to lint. Larger files are skipped.
    "harper.maxFileLength" = 120000;

    #> Path to a `harper-ls` executable. Empty = bundled.
    "harper.path" = "";

    #> Path to a user dictionary file. Empty = none.
    "harper.userDictPath" = "";

    #> Path (relative to workspace root) to a per-repo dictionary.
    #! overridden (default: "")
    "harper.workspaceDictPath" = ".harper-dictionary.txt";

    #~@ Linter Rules
    /**
    #> Per-rule on/off flags. Rule id = suffix after `harper.linters.`.
    #?  true  = rule active (report diagnostics)
    #?  false = rule disabled
    #! overridden (defaults: all rules active)

    #> Regenerate from upstream (exact list for your Harper version):
    ```sh
    curl -s 'https://api.github.com/repos/Automattic/harper/contents/harper-core/src/linting?ref=master' |
      jq -r '.[] |
      select(.type=="file") |
      .name |
      sub("\\.rs$";"") |
      select(. != "mod") |
      split("_") |
      map(ascii_upcase[0:1] + .[1:]) |
      join("")' |
      sort |
      awk '{print "# \"harper.linters." $0 "\" = true;"}'
    ```
    */


    #> Corrects `accuse for` to `accuse of`.
    "harper.linters.AccuseOf" = true;
    #> Corrects `a couple of more` to `a couple more`.
    "harper.linters.ACoupleMore" = true;
    #> Replaces `addicting` with `addictive` when used as an adjective.
    "harper.linters.Addicting" = true;
    #> Finds adjectives used with a double degree (`more prettier`).
    "harper.linters.AdjectiveDoubleDegree" = true;
    #> Looks for sequences of words of the form `adjective of a`.
    "harper.linters.AdjectiveOfA" = true;
    #> Corrects `as nauseam` to `ad nauseam`.
    "harper.linters.AdNauseam" = true;
    #> Corrects `adieu` to `ado`.
    "harper.linters.Ado" = true;
    #> Corrects the missing `of` in `take advantage of`.
    "harper.linters.AdvantageOf" = true;
    #> Corrects `afterall` to `after all`.
    "harper.linters.AfterAll" = true;
    #> Corrects missing article in `after while` → `after a while`.
    "harper.linters.AfterAWhile" = true;
    #> Checks for `later` following `after [period]`.
    "harper.linters.AfterLater" = true;
    #> Corrects `an` to `and` after `ahead`.
    "harper.linters.AheadAnd" = true;
    #> Corrects `a jar` to `ajar`.
    "harper.linters.Ajar" = true;
    #> Corrects `a kimbo` to `akimbo`.
    "harper.linters.Akimbo" = true;
    #> Corrects to `albeit`.
    "harper.linters.Albeit" = true;
    #> Corrects `a little of practice` to `a little practice`.
    "harper.linters.ALittleOfPractice" = true;
    #> Corrects `all hell breaks out` to `all hell breaks loose`.
    "harper.linters.AllHellBreakLoose" = true;
    #> Corrects wrong forms of `for all intents and purposes`.
    "harper.linters.AllIntentsAndPurposes" = true;
    #> Guides toward `all of a sudden`.
    "harper.linters.AllOfASudden" = true;
    #> Flags `allow to` without a subject.
    "harper.linters.AllowTo" = true;
    #> Flags `all ready` before an adjective (→ `already`).
    "harper.linters.AllReady" = true;
    #> Flags `all though` (→ `although`).
    "harper.linters.AllThough" = true;
    #> Corrects `all well in good` to `all well and good`.
    "harper.linters.AllWellAndGood" = true;
    #> Replaces `along side` with `alongside`.
    "harper.linters.Alongside" = true;
    #> Corrects `along time` to `a long time`.
    "harper.linters.ALongTime" = true;
    #> Fixes `old-timers' disease` to `Alzheimer’s disease`.
    "harper.linters.AlzheimersDisease" = true;
    #> Amazon product names must be proper nouns.
    "harper.linters.AmazonNames" = true;
    #> Corrects `a mean to an end` to `a means to an end`.
    "harper.linters.AMeansToAnEnd" = true;
    #> Americas must be proper nouns.
    "harper.linters.Americas" = true;
    #> Flags redundant am/pm + period indicators (`9 AM in the morning`).
    "harper.linters.AmInTheMorning" = true;
    #> Corrects `amounts for` to `amounts to` / `accounts for`.
    "harper.linters.AmountsFor" = true;
    #> Flags incorrect indefinite articles (`an mule`).
    "harper.linters.AnA" = true;
    #> Suggests standard terms for `analog bike` / `acoustic bike`.
    #! default: false
    "harper.linters.AnalogAcousticBike" = false;
    #> Corrects `an another` / `a another`.
    "harper.linters.AnAnother" = true;
    #> Fixes `an in` standing in for `and in`.
    "harper.linters.AndIn" = true;
    #> Corrects `and the such` to `and such`.
    "harper.linters.AndSuch" = true;
    #> Corrects `and the like` / `or the like`.
    "harper.linters.AndTheLike" = true;
    #> Corrects `another an` to `another`.
    "harper.linters.AnotherAn" = true;
    #> Corrects `another ones`.
    "harper.linters.AnotherOnes" = true;
    #> `another thing coming` is now more common than `another think coming`.
    "harper.linters.AnotherThingComing" = true;
    #> Corrects `another things`.
    "harper.linters.AnotherThings" = true;
    #> `another think coming` is the original phrase (vs. `another thing`).
    #! default: false
    "harper.linters.AnotherThinkComing" = false;
    #> Fixes spacing inside `anybody`.
    "harper.linters.Anybody" = true;
    #> Fixes spacing inside `anyhow`.
    "harper.linters.Anyhow" = true;
    #> Fixes spacing inside `anywhere`.
    "harper.linters.Anywhere" = true;
    #> Hyphenates `A-OK` when used adjectivally.
    "harper.linters.AOkHyphen" = true;
    #> Distinguishes `a part` from `apart`.
    "harper.linters.APart" = true;
    #> Fixes `apart form` → `apart from`.
    "harper.linters.ApartFrom" = true;
    #> Apple product/service names must be proper nouns.
    "harper.linters.AppleNames" = true;
    #> Corrects `argument to be said` → `argument to be made`.
    "harper.linters.ArgumentToBeMade" = true;
    #> Prefers `arrive on Friday` over bare weekday.
    "harper.linters.ArriveOnWeekday" = true;
    #> Corrects `arrive to` → `arrive at`/`arrive in`.
    "harper.linters.ArriveTo" = true;
    #> Corrects `as compare to` → `as compared to`.
    "harper.linters.AsComparedTo" = true;
    #> Corrects `evident by` → `evidenced by`.
    "harper.linters.AsEvidentBy" = true;
    #> Expands initialism `AFAICT`.
    "harper.linters.AsFarAsICanTell" = true;
    #> Expands initialism `AFAIK`.
    "harper.linters.AsFarAsIKnow" = true;
    #> Corrects `as early back as` → `as far back as`.
    "harper.linters.AsFarBackAs" = true;
    #> Corrects `as follow` → `as follows`.
    "harper.linters.AsFollows" = true;
    #> Corrects `as how` → `as to how`.
    "harper.linters.AsHow" = true;
    #> Corrects redundant `as if though`.
    "harper.linters.AsIfThough" = true;
    #> Flags `as is with anything` → `as with anything`.
    "harper.linters.AsIsWithAnything" = true;
    #> Corrects `as it so happens` → `as it happens`.
    "harper.linters.AsItHappens" = true;
    #> Expands initialism `AIUI`.
    "harper.linters.AsIUnderstandIt" = true;
    #> Flags `ask to us` / `tell to him` (superfluous `to`).
    "harper.linters.AskNoPreposition" = true;
    #> Corrects `aslong as` / `as long that` → `as long as`.
    "harper.linters.AsLongAs" = true;
    #> Corrects `as much than` → `as much as`.
    "harper.linters.AsMuchAs" = true;
    #> Corrects `as of currently` → `currently` / `as of now`.
    "harper.linters.AsOfCurrently" = true;
    #> Corrects `as of lately` → `lately` / `as of late`.
    "harper.linters.AsOfLately" = true;
    #> Removes redundant `a some time`.
    "harper.linters.ASomeTime" = true;
    #> Corrects `as oppose to` → `as opposed to`.
    "harper.linters.AsOpposedTo" = true;
    #> Corrects `aspire for` → `aspire to`.
    "harper.linters.AspireTo" = true;
    #> Expands initialism `ASAP`.
    "harper.linters.AsSoonAsPossible" = true;
    #> Corrects `to` → `as to` between adjectives and wh-words.
    "harper.linters.AsToInterrogative" = true;
    #> Corrects `at all cost` → `at all costs`.
    "harper.linters.AtAllCosts" = true;
    #> Corrects nonstandard variants of `at face value`.
    "harper.linters.AtFaceValue" = true;
    #> Fixes typo `at leas` → `at least`.
    "harper.linters.AtLeasToLeast" = true;
    #> Fixes typo `at lest` → `at least`.
    "harper.linters.AtLestToLeast" = true;
    #> Corrects `in the best of times` → `at the best of times`.
    "harper.linters.AtTheBestOfTimes" = true;
    #> Corrects `in the end of the day` → `at the end of the day`.
    "harper.linters.AtTheEndOfTheDay" = true;
    #> Corrects `at the expanse of` → `at the expense of`.
    "harper.linters.AtTheExpenseOf" = true;
    #> Corrects `in the very least` → `at the very least`.
    "harper.linters.AtTheVeryLeast" = true;
    #> Corrects `hearable` → `audible`.
    "harper.linters.Audible" = true;
    #> Australian states/territories/cities must be proper nouns.
    "harper.linters.Australia" = true;
    #> Reduces `and also` → `and`.
    "harper.linters.AvoidAndAlso" = true;
    #> Suggests expanded forms for contractions.
    #! default: false
    "harper.linters.AvoidContractions" = false;
    #> Flags offensive language, offers euphemisms.
    "harper.linters.AvoidCurses" = true;
    #> Suggests `await` or `wait for` — not both.
    "harper.linters.AwaitFor" = true;
    #> Corrects `aware about` → `aware of`.
    "harper.linters.AwareOf" = true;
    #> Corrects idiom `a ways to go` (missing article).
    "harper.linters.AWaysToGo" = true;
    #> Enforces `awhile` after verbs, `a while` elsewhere.
    "harper.linters.AWhile" = true;
    #> Corrects `a whole another` → `a whole other`.
    "harper.linters.AWholeOther" = true;
    #> Azure product names must be proper nouns.
    "harper.linters.AzureNames" = true;
    #> Corrects `backhand compliment` → `backhanded compliment`.
    "harper.linters.BackhandedCompliment" = true;
    #> Flags `back in the days` → `back in the day`.
    "harper.linters.BackInTheDay" = true;
    #> Fixes spacing inside `backplane`.
    "harper.linters.Backplane" = true;
    #> Changes `bed rap` → `bad rap`.
    "harper.linters.BadRap" = true;
    #> Distinguishes `bain` from `bane`.
    "harper.linters.BainBane" = true;
    #> Corrects `ban together` → `band together`.
    "harper.linters.BanTogether" = true;
    #> Corrects `bare-bone` → `bare-bones`.
    "harper.linters.BareBones" = true;
    #> Ensures `bear in mind` (not `bare in mind`).
    "harper.linters.BareInMind" = true;
    #> Flags `barely unusable` (double negative).
    "harper.linters.BarelyUn" = true;
    #> Corrects `bare with` → `bear with`.
    "harper.linters.BareWithMe" = true;
    #> Changes `baited breath` → `bated breath`.
    "harper.linters.BatedBreath" = true;
    #> Ensures passive `be allowed` after future negatives.
    "harper.linters.BeAllowed" = true;
    #> Detects `be + verb` where `be + adjective` fits (`be biased`).
    "harper.linters.BeBiased" = true;
    #> Fixes eggcorns of `beck and call`.
    "harper.linters.BeckAndCall" = true;
    #> Detects `be + verb` where `be + adjective` fits (`be concerned`).
    "harper.linters.BeConcerned" = true;
    #> Corrects `bee there` → `been there`.
    "harper.linters.BeenThere" = true;
    #> Enforces one-word `beforehand`.
    "harper.linters.Beforehand" = true;
    #> Corrects `behind the scene` → `behind the scenes`.
    "harper.linters.BehindTheScenes" = true;
    #> Flags `bellow` for `below`.
    "harper.linters.BellowBelow" = true;
    #> Detects `be + verb` where `be + adjective` fits (`be prejudiced`).
    "harper.linters.BePrejudiced" = true;
    #> Expands initialism `BRB`.
    "harper.linters.BeRightBack" = true;
    #> Detects `be + verb` where `be + adjective` fits (`be shocked`).
    "harper.linters.BeShocked" = true;
    #> Corrects `besides the point` → `beside the point`.
    "harper.linters.BesideThePoint" = true;
    #> Corrects `of all times` → `of all time` in superlatives.
    "harper.linters.BestOfAllTime" = true;
    #> Corrects `beat regards` → `best regards`.
    "harper.linters.BestRegards" = true;
    #> Rewrites `better of` → `better off` in comparatives.
    "harper.linters.BetterOffPhrase" = true;
    #> Corrects `better off served` → `better off`/`better served`.
    "harper.linters.BetterOffServed" = true;
    #> Corrects `better of with` → `better off with`.
    "harper.linters.BetterOffWith" = true;
    #> Enforces `beware of` (not other prepositions).
    "harper.linters.BewareOf" = true;
    #> Detects `be + verb` where `be + adjective` fits (`be worried`).
    "harper.linters.BeWorried" = true;
    #> Normalizes `black list` / `white list` → compound.
    "harper.linters.BlacklistWhitelist" = true;
    #> Fixes common errors in `blanket statement`.
    "harper.linters.BlanketStatement" = true;
    #> Enforces `Blu-ray` hyphenation.
    "harper.linters.BluRayHyphen" = true;
    #> Flags `boarder` (lodger) → `border` (edge).
    "harper.linters.BoarderBorder" = true;
    #> Corrects `bullocks` → `bollocks` (nonsense).
    "harper.linters.Bollocks" = true;
    #> Flags overused "boring" words.
    #! default: false
    "harper.linters.BoringWords" = false;
    #> Replaces `bough` → `bought` after subject pronouns.
    "harper.linters.Bought" = true;
    #> Flags `brandish` for `brand`.
    "harper.linters.BrandBrandish" = true;
    #> Suggests `brutality` (more common).
    "harper.linters.Brutality" = true;
    #> Enforces `built-in` as one word.
    "harper.linters.BuiltIn" = true;
    #> Corrects `by accident` (idiom).
    "harper.linters.ByAccident" = true;
    #> Corrects `by extent` → `by extension`.
    "harper.linters.ByExtension" = true;
    #> Fixes `by my own` → `on my own`/`by myself`.
    "harper.linters.ByOnesOwn" = true;
    #> Fixes spacing inside `bypass`.
    "harper.linters.Bypass" = true;
    #> Corrects `by the books` → `by the book`.
    "harper.linters.ByTheBook" = true;
    #> Expands initialism `BTW`.
    "harper.linters.ByTheWay" = true;
    #> Corrects wrong variants of `call it quits`.
    "harper.linters.CallItQuits" = true;
    #> Addresses non-idiomatic `call them as`.
    "harper.linters.CallThem" = true;
    #> Canadian provinces/territories/cities must be proper nouns.
    "harper.linters.Canada" = true;
    #> Corrects `can be seem` → `can be seen`.
    "harper.linters.CanBeSeen" = true;
    #> Suggests `can't` for `cant`.
    "harper.linters.Cant" = true;
    #> Corrects `way` → `wait` in `can't way to` etc.
    "harper.linters.CantWay" = true;
    #> "Capitalize on" — collection run as one.
    "harper.linters.CapitalizeOn" = true;
    #> Requires capitalisation of `I`, `I'm`, etc.
    "harper.linters.CapitalizePersonalPronouns" = true;
    #> Corrects `case and point` → `case in point`.
    "harper.linters.CaseInPoint" = true;
    #> Hyphenates `case-sensitive`.
    "harper.linters.CaseSensitive" = true;
    #> Corrects soundalike confusion in `catch 22`.
    "harper.linters.Catch22" = true;
    #> Normalises `cause it is` → standard subordinating form.
    "harper.linters.CauseItIsBecause" = true;
    #> Distinguishes `tale` (story) from `tail` (appendage).
    "harper.linters.CautionaryTale" = true;
    #> Catches `seize to` (typo for `cease to`).
    "harper.linters.CeaseTo" = true;
    #> Fixes spacing inside `chalkboard`.
    "harper.linters.Chalkboard" = true;
    #> Corrects `chomp at the bit` → `champ at the bit`.
    "harper.linters.ChampAtTheBit" = true;
    #> Corrects `change tack` idiom variants.
    "harper.linters.ChangeTack" = true;
    #> Corrects wrong variants of `chicken-and-egg`.
    "harper.linters.ChickenAndEgg" = true;
    #> CCP name must be a proper noun.
    "harper.linters.ChineseCommunistParty" = true;
    #> Corrects soundalikes of `chock-full`; enforces hyphen.
    "harper.linters.ChockFull" = true;
    #> Corrects `claim for fame` → `claim to fame`.
    "harper.linters.ClaimToFame" = true;
    #> Cliché collection (`accent`).
    "harper.linters.ClicheAccent" = true;
    #> Hyphenates `click-through-rate` in analytics contexts.
    "harper.linters.ClickThroughRate" = true;
    #> Corrects `client's side` → `client-side`.
    "harper.linters.ClientOrServerSide" = true;
    #> Corrects `close-nit`/`tight-nit` → `close-knit`/`tight-knit`.
    "harper.linters.CloseTightKnit" = true;
    #> Fixes spacing inside `codebase`.
    "harper.linters.Codebase" = true;
    #> Fixes spacing inside `codebases`.
    "harper.linters.Codebases" = true;
    #> Corrects `code on` → `code in` (writing code).
    "harper.linters.CodeInWriteIn" = true;
    #> Rewrites `cold` → `could` in modal contexts.
    "harper.linters.ColdModalTypo" = true;
    #> Suggests `combine` for `combinate`.
    "harper.linters.Combinate" = true;
    #> Corrects `comfortable of` → `comfortable with`.
    "harper.linters.ComfortableWith" = true;
    #> Fixes comma spacing, `，` for `,`, etc.
    "harper.linters.CommaFixes" = true;
    #> Corrects `commitment toward` → `commitment to`.
    "harper.linters.CommitmentTo" = true;
    #> Ensures proper capitalisation of companies/brands.
    "harper.linters.CompaniesProductsAndTrademarks" = true;
    #> Corrects `complain` used as a noun.
    "harper.linters.ComplainAsNoun" = true;
    #> Merges split compound nouns.
    "harper.linters.CompoundNouns" = true;
    #> Promotes `I` in compound subjects with a possessive determiner.
    "harper.linters.CompoundSubjectI" = true;
    #> `Comprises` already contains `of`.
    "harper.linters.ComprisesOf" = true;
    #> Suggests `compel` for `compulse`.
    "harper.linters.CompulseToCompel" = true;
    #> Suggests `condense` for `condensate` (verb).
    "harper.linters.CondensateVerb" = true;
    #> Suggests `all the` for `all of the`.
    "harper.linters.CondenseAllThe" = true;
    #> Corrects `confidant` → `confident` (adjective).
    "harper.linters.Confident" = true;
    #> Corrects `conform` typos → `confirm`.
    "harper.linters.ConfirmThat" = true;
    #> Removes extraneous `as` after `constitute`.
    "harper.linters.ConstituteAs" = true;
    #> Corrects `convenient store` → `convenience store`.
    "harper.linters.ConvenientStore" = true;
    #> Corrects `copywrite` → `copyright`.
    "harper.linters.Copyright" = true;
    #> Catches mismatched number suffixes (`2st`).
    "harper.linters.CorrectNumberSuffix" = true;
    #> Country names must be proper nouns.
    "harper.linters.Countries" = true;
    #> `Coursing` (flowing) vs eggcorn `cursing` through veins.
    "harper.linters.CoursingThroughVeins" = true;
    #> Removes `for` after `crave`.
    "harper.linters.CraveFor" = true;
    #> `criteria`/`phenomena` are plural forms.
    "harper.linters.CriteriaPhenomena" = true;
    #> Enforces `cross-platform` hyphenation.
    "harper.linters.CrossPlatform" = true;
    #> Prefers `cure for`.
    "harper.linters.CureFor" = true;
    #> Corrects `curious of`/`curious on` → `curious about`.
    "harper.linters.CuriousAbout" = true;
    #> Corrects improper placement of currency symbols.
    "harper.linters.CurrencyPlacement" = true;
    #> Corrects `cutting age` → `cutting-edge`.
    "harper.linters.CuttingAgeEggcorn" = true;
    #> Expands `cybersec` → `cybersecurity`.
    "harper.linters.Cybersec" = true;
    #> Checks plural `damages` outside legal context.
    "harper.linters.Damages" = true;
    #> Corrects `damp squid` → `damp squib`.
    "harper.linters.DampSquib" = true;
    #> Writers often type `--` or `---` expecting their editor to convert them into proper dashes. Replace these sequences with the correct characters: use an en dash (–) for ranges or connections and an em dash (—) for a break in thought.
    "harper.linters.Dashes" = false; #! overridden
    #> Corrects blended `date back from`.
    "harper.linters.DateBackFrom" = true;
    #> Fixes `in this day and age` variants.
    "harper.linters.DayAndAge" = true;
    #> Day One brand names must be proper nouns.
    "harper.linters.DayOneNames" = true;
    #> Fixes spacing inside `deadlift`.
    "harper.linters.Deadlift" = true;
    #> `the` is a definite article.
    "harper.linters.DefiniteArticle" = true;
    #> Corrects `degrees kelvin` → `kelvins`.
    "harper.linters.DegreesKelvin" = true;
    #> Corrects `°K` → `K`.
    "harper.linters.DegreesKelvinSymbol" = true;
    #> Corrects `deny offer` → `decline`/`reject`.
    "harper.linters.DenyOffer" = true;
    #> Dereference collection.
    "harper.linters.Dereference" = true;
    #> Fixes spacing inside `desktop`.
    "harper.linters.Desktop" = true;
    #> Corrects wrong form of `is` after `despite`.
    "harper.linters.DespiteItIs" = true;
    #> Corrects `despite of` → `despite`/`in spite of`.
    "harper.linters.DespiteOf" = true;
    #> Fixes spacing inside `devops`.
    "harper.linters.Devops" = true;
    #> Corrects `dint` → `didn't` after subject pronouns.
    "harper.linters.Didnt" = true;
    #> Uses base form of verbs with `did`.
    "harper.linters.DidPast" = true;
    #> Corrects `digestive track` → `digestive tract`.
    "harper.linters.DigestiveTract" = true;
    #> Flags mixed metaphor `digging under the hood`.
    "harper.linters.DigUnderTheHood" = true;
    #> Requires comma after discourse markers at sentence start.
    "harper.linters.DiscourseMarkers" = true;
    #> Removes `about` after `discuss`.
    "harper.linters.Discuss" = true;
    #> Joins prefixed words that were split with a space.
    "harper.linters.DisjointPrefixes" = true;
    #> Distinguishes `dissemble` from `disassemble`.
    "harper.linters.DissembleDisassemble" = true;
    #> Corrects typos of `dose` → `does`.
    "harper.linters.DoesOrDose" = true;
    #> Swaps `do` → `am` in `Do I <adjective>` questions.
    "harper.linters.DoIAdjective" = true;
    #> Corrects `do a mistake` → `make a mistake`.
    "harper.linters.DoMistake" = true;
    #> Flags truncation `wan` (from `want`).
    "harper.linters.DoNotWant" = true;
    #> Corrects `don't can` → `can't`/`cannot`.
    "harper.linters.DontCan" = true;
    #> Ensures proper dot-separated initialisms.
    "harper.linters.DotInitialisms" = true;
    #> Corrects `do to` → `due to` in causal phrases.
    "harper.linters.DoToDueTo" = true;
    #> Normalises `double check` → `double-check`.
    "harper.linters.DoubleCheckHyphen" = true;
    #> Enforces `double-click` hyphen.
    "harper.linters.DoubleClick" = true;
    #> Corrects `double-edged sword` variants.
    "harper.linters.DoubleEdgedSword" = true;
    #> Flags two modals in a row.
    "harper.linters.DoubleModal" = true;
    #> Collapses double negation (`didn't have no` → `any`).
    "harper.linters.DoubleNegative" = true;
    #> Corrects `do diligence` → `due diligence`.
    "harper.linters.DueDiligence" = true;
    #> Prefers `for ages`.
    "harper.linters.DuringAges" = true;
    #> Corrects `each and everyone` → `each and every one`.
    "harper.linters.EachAndEveryOne" = true;
    #> Rewrites `each others` → `each other's`.
    "harper.linters.EachOthersPossessive" = true;
    #> Hyphenates `eagle-eyed` as compound modifier.
    "harper.linters.EagleEyed" = true;
    #> Hyphenates `easy-going` before nouns.
    "harper.linters.EasyGoingCompoundAdjective" = true;
    #> Corrects `egg yoke` → `egg yolk`.
    "harper.linters.EggYolk" = true;
    #> Validates number of dots in an ellipsis.
    "harper.linters.EllipsisLength" = true;
    #> Corrects missing apostrophe in `someone elses`.
    "harper.linters.ElsePossessive" = true;
    #> Corrects `eluded to` → `alluded to`.
    "harper.linters.EludedTo" = true;
    #> Suggests `en masse` for `on mass`/`in mass`.
    "harper.linters.EnMasse" = true;
    #> Suggests `en route` for `on route`/`in route`.
    "harper.linters.EnRoute" = true;
    #> Environment variable naming.
    "harper.linters.EnvironmentVariable" = true;
    #> Corrects typos of `every` → `ever`.
    "harper.linters.EverEvery" = true;
    #> Hyphenates `ever-present`.
    "harper.linters.EverPresent" = true;
    #> Removes redundant relative pronoun after `whatever`/`whoever`.
    "harper.linters.EverPronounRelPronoun" = true;
    #> Corrects `every since` → `ever since`.
    "harper.linters.EverSince" = true;
    #> Fixes spacing inside `everybody`.
    "harper.linters.Everybody" = true;
    #> Distinguishes `everyday` from `every day`.
    "harper.linters.Everyday" = true;
    #> Corrects `every once and again`.
    "harper.linters.EveryOnceAndAgain" = true;
    #> Fixes spacing inside `everyone`.
    "harper.linters.Everyone" = true;
    #> Detects missing `one` in `every single one of`.
    "harper.linters.EverySingleOneOf" = true;
    #> Corrects `everytime` → `every time`.
    "harper.linters.EveryTime" = true;
    #> Fixes spacing inside `everywhere`.
    "harper.linters.Everywhere" = true;
    #> Prefers `excellent` over `very good`.
    "harper.linters.Excellent" = true;
    #> Corrects `except of` → `except for`.
    "harper.linters.ExceptOf" = true;
    #> Changes `exited` → `excited` in enthusiasm contexts.
    "harper.linters.ExitedExcitedContext" = true;
    #> Expands `algo` → `algorithm`.
    "harper.linters.ExpandAlgorithm" = true;
    #> Expands `alloc` → `allocate`/`allocation`.
    "harper.linters.ExpandAlloc" = true;
    #> Expands `arg` → `argument`.
    "harper.linters.ExpandArgument" = true;
    #> Expands `cuz` → `because`.
    "harper.linters.ExpandBecause" = true;
    #> Configuration expansion collection.
    "harper.linters.ExpandConfiguration" = true;
    #> Expands `ctrl` → `control`.
    "harper.linters.ExpandControl" = true;
    #> Expands `coord` → `coordinate`.
    "harper.linters.ExpandCoordinate" = true;
    #> Expands `decl` → `declaration`/`declarator`.
    "harper.linters.ExpandDecl" = true;
    #> Expands `deps` → `dependencies`.
    "harper.linters.ExpandDependencies" = true;
    #> Expands `deref` → `dereference`.
    "harper.linters.ExpandDereference" = true;
    #> Expands `dir` → `directory`.
    "harper.linters.ExpandDirectory" = true;
    #> Expands `fav`/`fave` → `favorite`/`favourite`.
    "harper.linters.ExpandFavourite" = true;
    #> Expands `fwd` → `forward`.
    "harper.linters.ExpandForward" = true;
    #> Expands `govt` → `government`.
    "harper.linters.ExpandGovt" = true;
    #> Expands `legit` → `legitimate`.
    "harper.linters.ExpandLegitimate" = true;
    #> Expands memory shorthand (`MB` → `megabyte`, etc.).
    "harper.linters.ExpandMemoryShorthands" = true;
    #> Expands `min` → `minimum`.
    "harper.linters.ExpandMinimum" = true;
    #> Expands `notif` → `notification`.
    "harper.linters.ExpandNotification" = true;
    #> Expands `param` → `parameter`.
    "harper.linters.ExpandParameter" = true;
    #> Expands `ppl` → `people`.
    "harper.linters.ExpandPeople" = true;
    #> Expands `perf` → `performance`.
    "harper.linters.ExpandPerformance" = true;
    #> Expands `ptr` → `pointer`.
    "harper.linters.ExpandPointer" = true;
    #> Preference expansion collection.
    "harper.linters.ExpandPreference" = true;
    #> Expands `prev` → `previous`.
    "harper.linters.ExpandPrevious" = true;
    #> Expands `stdin`/`stdout`/`stderr`.
    "harper.linters.ExpandStandardInputAndOutput" = true;
    #> Expands `tho` → `though`.
    "harper.linters.ExpandThough" = true;
    #> Expands `thru` → `through`.
    "harper.linters.ExpandThrough" = true;
    #> Expands `hr`/`min`/`sec`/etc.
    "harper.linters.ExpandTimeShorthands" = true;
    #> Expands `vuln` → `vulnerability`.
    "harper.linters.ExpandVulnerability" = true;
    #> Expands `w/` → `with`.
    "harper.linters.ExpandWith" = true;
    #> Expands `w/o` → `without`.
    "harper.linters.ExpandWithout" = true;
    #> Fixes split `expat`.
    "harper.linters.Expat" = true;
    #> Fixes `expatriate` misuse.
    "harper.linters.Expatriate" = true;
    #> Expands initialism `ELI5`.
    "harper.linters.ExplainLikeImFive" = true;
    #> Corrects `explanation mark` → `exclamation mark`.
    "harper.linters.ExplanationMark" = true;
    #> Corrects `extend` → `extent` in noun contexts.
    "harper.linters.ExtendOrExtent" = true;
    #> Hyphenates `face-first`.
    "harper.linters.FaceFirst" = true;
    #> Fixes malapropisms of `a fair bit`.
    "harper.linters.FairBit" = true;
    #> Flags redundant `below` after fall distances.
    "harper.linters.FallBelow" = true;
    #> Corrects `far and few between` → `few and far between`.
    "harper.linters.FarAndFewBetween" = true;
    #> Flags `far be it` (missing `from`).
    "harper.linters.FarBeIt" = true;
    #> Ensures correct prepositions for `fascinated`.
    "harper.linters.FascinatedBy" = true;
    #> Detects `fast paste` → `fast-paced`.
    "harper.linters.FastPaste" = true;
    #> Replaces `fatal outcome` → `death`.
    "harper.linters.FatalOutcome" = true;
    #> Corrects `fed up of` → `fed up with` (non-British).
    "harper.linters.FedUpWith" = true;
    #> Corrects `fell` → `feel` expressions.
    "harper.linters.FeelFell" = true;
    #> Corrects redundant `fellow` + `co-`.
    "harper.linters.FellowCoRedundancy" = true;
    #> Ensures `fetal position` (not `feeble position`).
    "harper.linters.FetalPosition" = true;
    #> Corrects `few` → `a few` before time units.
    "harper.linters.FewUnitsOfTimeAgo" = true;
    #> Removes filler words.
    "harper.linters.FillerWords" = true;
    #> Fixes `find` → `fine`.
    "harper.linters.FindFine" = true;
    #> Flags `find out` where `find` is better.
    "harper.linters.FindOut" = true;
    #> Corrects `finish touches` → `finishing touches`.
    "harper.linters.FinishingTouches" = true;
    #> Detects `first aid kid` (should be `kit`).
    "harper.linters.FirstAidKit" = true;
    #> Hyphenates ordinal-person modifiers.
    "harper.linters.FirstPersonModifierHyphen" = true;
    #> Corrects `neither fish nor foul` → `neither fish nor fowl`.
    "harper.linters.FishNorFowl" = true;
    #> Corrects `flaunt` → `flout` with rule-like nouns.
    "harper.linters.FlauntForFlout" = true;
    #> Corrects `flesh out` vs `full-fledged`.
    "harper.linters.FleshOutVsFullFledged" = true;
    #> Corrects `foam out the mouth` → `foam at the mouth`.
    "harper.linters.FoamAtTheMouth" = true;
    #> Flags `fond on` → `found on`/`fond of`.
    "harper.linters.FondOn" = true;
    #> Corrects `'` and `"` for measurements to prime/double-prime.
    "harper.linters.FootInchMinuteSecondSymbols" = true;
    #> Corrects `flip the bill` → `foot the bill`.
    "harper.linters.FootTheBill" = true;
    #> Eliminates incorrect `for along time`.
    "harper.linters.ForALongTime" = true;
    #> Corrects `for argument sake` → `for argument's sake`.
    "harper.linters.ForArgumentsSake" = true;
    #> Corrects `for while` → `for a while`.
    "harper.linters.ForAWhile" = true;
    #> Corrects `for free of charge`.
    "harper.linters.ForFreeOfCharge" = true;
    #> Corrects `formidable years` → `formative years`.
    "harper.linters.FormativeYears" = true;
    #> Corrects archaic `fro` → `for` before nouns.
    "harper.linters.ForNoun" = true;
    #> Detects `reason` vs `reasons` misuse.
    "harper.linters.ForSameReason" = true;
    #> Corrects `for most part` → `for the most part`.
    "harper.linters.ForTheMostPart" = true;
    #> Adds missing `the` for nth occurrences.
    "harper.linters.ForTheNthTime" = true;
    #> Expands initialism `FWIW`.
    "harper.linters.ForWhatItsWorth" = true;
    #> Expands initialism `FYI`.
    "harper.linters.ForYourInformation" = true;
    #> Swaps `fee` → `free` after a linking verb.
    "harper.linters.FreePredicate" = true;
    #> Ensures `free rein` (not `free reign`).
    "harper.linters.FreeRein" = true;
    #> Suggests `freezing` for `very cold`.
    "harper.linters.Freezing" = true;
    #> Corrects `a friend of me` → `a friend of mine`.
    "harper.linters.FriendOfMe" = true;
    #> Hyphenates `from the get-go`.
    "harper.linters.FromTheGetGo" = true;
    #> Corrects wrong preposition `full to the brim`.
    "harper.linters.FullToTheBrim" = true;
    #> Fixes spacing inside `furthermore`.
    "harper.linters.Furthermore" = true;
    #> Corrects `pass` → `past` after `get`/`go`.
    "harper.linters.GetPassGoPass" = true;
    #> Corrects misspellings of `get rid of`.
    "harper.linters.GetRidOf" = true;
    #> Corrects `used of` → `used to`.
    "harper.linters.GetUsedTo" = true;
    #> Uses `Gilded Age` for the period.
    "harper.linters.GildedAge" = true;
    #> Corrects `goggle` in Google product context.
    "harper.linters.GoggleBrand" = true;
    #> Corrects `gong to` → `going to`.
    "harper.linters.GoingTo" = true;
    #> Corrects `become missing` → `go missing`.
    "harper.linters.GoMissing" = true;
    #> Corrects `good in` → `good at` for proficiency.
    "harper.linters.GoodAt" = true;
    #> Google product names must be proper nouns.
    "harper.linters.GoogleNames" = true;
    #> Flags `go so far to` → `go so far as to`.
    "harper.linters.GoSoFarAsTo" = true;
    #> Corrects `go into sleep` → `go to sleep`.
    "harper.linters.GoToSleep" = true;
    #> Replaces `go at war` → `go to war`.
    "harper.linters.GoToWar" = true;
    #> Corrects `grind to halt` → `grind to a halt`.
    "harper.linters.GrindToAHalt" = true;
    #> Fixes spacing inside `guesswork`.
    "harper.linters.Guesswork" = true;
    #> Corrects `Guinea-Bissau`.
    "harper.linters.GuineaBissau" = true;
    #> Flags unnecessary `of` after `had`.
    "harper.linters.HadOf" = true;
    #> Fixes `half an our` → `half an hour`.
    "harper.linters.HalfAnHour" = true;
    #> Corrects `hallucinization`.
    "harper.linters.Hallucination" = true;
    #> Keeps `handful` as one word.
    "harper.linters.Handful" = true;
    #> Removes nonstandard `of` from `handful of more`.
    "harper.linters.HandfulOfMore" = true;
    #> Corrects `half hazard` → `haphazard`.
    "harper.linters.Haphazard" = true;
    #> Corrects `have hard time` → `have a hard time`.
    "harper.linters.HaveAHardTime" = true;
    #> Rewrites `no` → `any` in `haven't done no X`.
    "harper.linters.HaveNegNoAny" = true;
    #> Suggests `past` for `passed` after `have`.
    "harper.linters.HavePassed" = true;
    #> Flags `has we`/`has I` → `have`.
    "harper.linters.HavePronoun" = true;
    #> Corrects `have a look` vs `take a look` by dialect.
    "harper.linters.HaveTakeALook" = true;
    #> Hazzle collection.
    "harper.linters.Hazzle" = true;
    #> Corrects `heart`/`herd` → `heard`.
    "harper.linters.HeartToHeard" = true;
    #> Flags hedging language.
    "harper.linters.Hedging" = true;
    #> Corrects `dos` → `does` after he/she/it.
    "harper.linters.HeDos" = true;
    #> Prefers `hello` for greeting (not `halo`).
    "harper.linters.HelloGreeting" = true;
    #> Base form of verbs after `helped`.
    "harper.linters.HelpedPast" = true;
    #> Fixes spacing inside `henceforth`.
    "harper.linters.Henceforth" = true;
    #> Corrects `here by` → `hereby`.
    "harper.linters.Hereby" = true;
    #> Corrects `hidden into` → `hidden in`.
    "harper.linters.HiddenIn" = true;
    #> Corrects `high/low standard` → `standards`.
    "harper.linters.HighLowStandards" = true;
    #> Corrects misspellings of `hijack`.
    "harper.linters.Hijack" = true;
    #> Corrects `hit the nail in the head` → `on the head`.
    "harper.linters.HitTheNailOnTheHead" = true;
    #> Holiday names must be proper nouns.
    "harper.linters.Holidays" = true;
    #> Corrects misspellings of `holy war`.
    "harper.linters.HolyWar" = true;
    #> Corrects `hone in on` → `home in on`.
    "harper.linters.HomeInOn" = true;
    #> Handles `hop`/`hope` errors.
    "harper.linters.HopHope" = true;
    #> Corrects `how do/does compared`.
    "harper.linters.HowDoesCompared" = true;
    #> Fixes spacing inside `however`.
    "harper.linters.However" = true;
    #> Corrects `how ... looks like`.
    "harper.linters.HowItLooksLike" = true;
    #> Corrects `how mach`/`how match` → `how much`.
    "harper.linters.HowMach" = true;
    #> Detects missing `to` in `how clone` → `how to …`.
    "harper.linters.HowTo" = true;
    #> Eliminates `human's beings`/`humans beings`.
    "harper.linters.HumanBeings" = true;
    #> Corrects `human live` → `human life`.
    "harper.linters.HumanLife" = true;
    #> Corrects `hunger pain` → `hunger pang`.
    "harper.linters.HungerPang" = true;
    #> Hyphenates `4-day` compound adjectives.
    "harper.linters.HyphenateNumberDay" = true;
    #> Fixes `I a m` → `I am`.
    "harper.linters.IAm" = true;
    #> Corrects `I are` → `I am`.
    "harper.linters.IAmAgreement" = true;
    #> Corrects `I does` → `I do`.
    "harper.linters.IDo" = true;
    #> Expands initialism `IDK`.
    "harper.linters.IDontKnow" = true;
    #> Expands initialism `IIRC`.
    "harper.linters.IfIRecallCorrectly" = true;
    #> Expands initialism `IICU`.
    "harper.linters.IfIUnderstandCorrectly" = true;
    #> Corrects `if I would've done` → `if I had done`.
    "harper.linters.IfWouldve" = true;
    #> Expands initialism `IYKYK`.
    "harper.linters.IfYouKnowYouKnow" = true;
    #> After `imitate ...`, prefer `of`.
    "harper.linters.ImitateFrom" = true;
    #> Corrects `implement into` → `implement in`.
    "harper.linters.ImplementIn" = true;
    #> Corrects `impressed of` → `impressed by`/`with`.
    "harper.linters.Impressed" = true;
    #> Corrects `into` → `in` for direction/strategy changes.
    "harper.linters.InADifferentDirection" = true;
    #> Corrects `in hurry` → `in a hurry`.
    "harper.linters.InAHurry" = true;
    #> Corrects `in ideal world` → `in an ideal world`.
    "harper.linters.InAnIdealWorld" = true;
    #> Corrects ungrammatical `in anyway` → `in any way`.
    "harper.linters.InAnyWay" = true;
    #> Corrects `in while` → `in a while`.
    "harper.linters.InAWhile" = true;
    #> Expands initialism `ICYMI`.
    "harper.linters.InCaseYouMissedIt" = true;
    #> Incident report collection.
    "harper.linters.IncidentReport" = true;
    #> Adds commas around `including, but not limited to,`.
    "harper.linters.IncludingButNotLimitedToPunctuation" = true;
    #> Hyphenates `in-demand` / `in-depth` as adjectives.
    "harper.linters.InDemandInDepth" = true;
    #> Corrects `in details` → `in detail`.
    "harper.linters.InDetail" = true;
    #> Corrects `in do course` → `in due course`.
    "harper.linters.InDueCourse" = true;
    #> Adds missing `of` in `in favour of doing`.
    "harper.linters.InFavourOfDoing" = true;
    #> Flags non-infinitive verb after `to`.
    "harper.linters.InflectedVerbAfterTo" = true;
    #> Corrects `infliction point` → `inflection point`.
    "harper.linters.InflectionPoint" = true;
    #> Corrects `in hindsight` variants.
    "harper.linters.InHindsight" = true;
    #> Corrects nonstandard `initiatively`.
    "harper.linters.Initiatively" = true;
    #> Corrects `in lue of` → `in lieu of`.
    "harper.linters.InLieuOf" = true;
    #> Expands initialism `IMHO`.
    "harper.linters.InMyHumbleOpinion" = true;
    #> Expands initialism `IMO`.
    "harper.linters.InMyOpinion" = true;
    #> Corrects `in need for` → `in need of`.
    "harper.linters.InNeedOf" = true;
    #> In-of-itself collection.
    "harper.linters.InOfItself" = true;
    #> Corrects `to my defense` → `in my defense`.
    "harper.linters.InOnesDefense" = true;
    #> Corrects `in/on the cards` by dialect.
    "harper.linters.InOnTheCards" = true;
    #> Expands initialism `IRL`.
    "harper.linters.InRealLife" = true;
    #> Corrects `in retaliation to`.
    "harper.linters.InRetaliationTo" = true;
    #> Suggests `insensitive` (more common).
    "harper.linters.Insensitive" = true;
    #> Fixes spacing inside `insofar`.
    "harper.linters.Insofar" = true;
    #> Corrects `inspired from` → `inspired by`.
    "harper.linters.InspiredBy" = true;
    #> Fixes spacing inside `instead`.
    "harper.linters.Instead" = true;
    #> Corrects `in stead of` → `instead of`.
    "harper.linters.InsteadOf" = true;
    #> Corrects `on stock` → `in stock`.
    "harper.linters.InStock" = true;
    #> Suggests `insurmountable` (more common).
    "harper.linters.Insurmountable" = true;
    #> Fixes spacing inside `intact`.
    "harper.linters.Intact" = true;
    #> Ensures `interested in`.
    "harper.linters.InterestedIn" = true;
    #> Corrects `int he` → `in the`.
    "harper.linters.InThe" = true;
    #> Corrects `at the first place` → `in the first place`.
    "harper.linters.InTheFirstPlace" = true;
    #> Corrects `in the grand scheme of things` variants.
    "harper.linters.InTheGrandSchemeOfThings" = true;
    #> Corrects `in the same vein` variants.
    "harper.linters.InTheSameVein" = true;
    #> Corrects `in this/that regards` → `regard`.
    "harper.linters.InThisThatRegard" = true;
    #> Removes redundant `in` before `[period] from now`.
    "harper.linters.InTimeFromNow" = true;
    #> Adds missing comma in `No thanks`.
    "harper.linters.IntroCueCommaBeforeThanks" = true;
    #> `Invest` pairs with `in`.
    "harper.linters.InvestIn" = true;
    #> Rewrites `is been` to standard perfect-passive.
    "harper.linters.IsBeenAuxSequence" = true;
    #> `known` is the past participle.
    "harper.linters.IsKnownFor" = true;
    #> Corrects `It cam` → `It can`.
    "harper.linters.ItCan" = true;
    #> Corrects `it looks like that` → `it looks like`.
    "harper.linters.ItLooksLikeThat" = true;
    #> Distinguishes `its` from `it's` before verbs/clauses.
    "harper.linters.ItsContraction" = true;
    #> Fixes spacing inside `itself`.
    "harper.linters.Itself" = true;
    #> `its` (possessive) never takes an apostrophe.
    "harper.linters.ItsPossessive" = true;
    #> Adds `'s` in `it time to/for`.
    "harper.linters.ItTimeAuxiliary" = true;
    #> Corrects `I've go to` → `I've got to`.
    "harper.linters.IveGotTo" = true;
    #> Corrects `jar-dropping` → `jaw-dropping`.
    "harper.linters.JawDropping" = true;
    #> Prefers `jealous of`.
    "harper.linters.JealousOf" = true;
    #> Jetpack product names must be proper nouns.
    "harper.linters.JetpackNames" = true;
    #> Recommends `Johns Hopkins`.
    "harper.linters.JohnsHopkins" = true;
    #> Detects `jump the gun` misuse.
    "harper.linters.JumpTheGun" = true;
    #> Ensures `just deserts`.
    "harper.linters.JustDeserts" = true;
    #> Fixes spacing inside `keystroke`.
    "harper.linters.Keystroke" = true;
    #> Fixes spacing inside `keystrokes`.
    "harper.linters.Keystrokes" = true;
    #> Corrects `kinda of` → `kind of`.
    "harper.linters.KindOf" = true;
    #> Corrects `kid regards` → `kind regards`.
    "harper.linters.KindRegards" = true;
    #> Fixes `kind if`/`sort off` before qualifiers.
    "harper.linters.KindSortOf" = true;
    #> Corrects `no nothing` → `know nothing`.
    "harper.linters.KnowNothingVerb" = true;
    #> Korea names must be proper nouns.
    "harper.linters.Koreas" = true;
    #> Laos names must be proper nouns.
    "harper.linters.Laos" = true;
    #> Fixes spacing inside `laptop`.
    "harper.linters.Laptop" = true;
    #> Corrects `last but not least` variants.
    "harper.linters.LastButNotLeast" = true;
    #> Corrects `last-ditch` variants.
    "harper.linters.LastDitch" = true;
    #> Flags `yesterday night` → `last night`.
    "harper.linters.LastNight" = true;
    #> Nudges `laugh of` → `laugh at`.
    "harper.linters.LaughOfAt" = true;
    #> Flags nonstandard `layout` verb forms.
    "harper.linters.LayoutVerb" = true;
    #> Corrects `leads rise to` → `gives rise to`.
    "harper.linters.LeadRiseTo" = true;
    #> Prefers `leave for a destination`.
    "harper.linters.LeaveToFor" = true;
    #> Corrects `leaving in drones` → `leaving in droves`.
    "harper.linters.LeavingInDroves" = true;
    #> Hyphenates `left-hand`/`right-hand` as adjectives.
    "harper.linters.LeftRightHand" = true;
    #> Suggests alternatives to `less worse`/`least worst`.
    "harper.linters.LessWorse" = true;
    #> Corrects `let along` → `let alone`.
    "harper.linters.LetAlone" = true;
    #> Expands initialism `LMK`.
    "harper.linters.LetMeKnow" = true;
    #> Handles `let` errors.
    "harper.linters.LetsConfusion" = true;
    #> Corrects extraneous `to` after `let`.
    "harper.linters.LetToDo" = true;
    #> Corrects `level of details`.
    "harper.linters.LevelOfDetails" = true;
    #> Fixes spacing inside `lifetime`.
    "harper.linters.Lifetime" = true;
    #> Corrects `like as if`.
    "harper.linters.LikeAsIf" = true;
    #> Joins `likely hood` → `likelihood`.
    "harper.linters.LikelyHood" = true;
    #> Corrects `like a plague` → `like the plague`.
    "harper.linters.LikeThePlague" = true;
    #> Corrects `like no tomorrow` → `like there's no tomorrow`.
    "harper.linters.LikeTheresNoTomorrow" = true;
    #> Fixes spacing inside `likewise`.
    "harper.linters.Likewise" = true;
    #> Corrects `line of codes` → `lines of code`.
    "harper.linters.LinesOfCode" = true;
    #> Linked-list collection.
    "harper.linters.LinkedList" = true;
    #> Suggests direct positives for litotes.
    "harper.linters.LitotesDirectPositive" = true;
    #> Fixes `little known`.
    "harper.linters.LittleKnown" = true;
    #> Flags overly long sentences.
    "harper.linters.LongSentences" = true;
    #> Adds `a` before `long time ago`.
    "harper.linters.LongTimeAgo" = true;
    #> Corrects `look-a-like`.
    "harper.linters.Lookalike" = true;
    #> Corrects `look one's nose down`.
    "harper.linters.LookDownOnesNose" = true;
    #> Corrects `look forward for` → `look forward to`.
    "harper.linters.LookForwardTo" = true;
    #> Requires gerund after `looking forward to`.
    "harper.linters.LookingForwardTo" = true;
    #> Joins `look into` before clauses.
    "harper.linters.LookInto" = true;
    #> Corrects `looks likes` → `look ... like`.
    "harper.linters.LooksLikes" = true;
    #> Lots collection.
    "harper.linters.Lots" = true;
    #> Corrects `low-hanging fruit` variants.
    "harper.linters.LowHangingFruit" = true;
    #> Corrects `make due with` → `make do with`.
    "harper.linters.MakeDoWith" = true;
    #> Corrects `make it seems` → `make it seem`.
    "harper.linters.MakeItSeem" = true;
    #> Corrects `make senses` → `make sense`.
    "harper.linters.MakeSense" = true;
    #> Joins `makeup` as compound noun.
    "harper.linters.MakeupCompoundNoun" = true;
    #> Malaysia names must be proper nouns.
    "harper.linters.Malaysia" = true;
    #> Corrects `managerial reigns` → `reins`.
    "harper.linters.ManagerialReins" = true;
    #> Corrects `max exodues` → `mass exodus`.
    "harper.linters.MassExodus" = true;
    #> Detects count usage of mass nouns.
    "harper.linters.MassNouns" = true;
    #> May + pronoun construction.
    "harper.linters.MayOfPronoun" = true;
    #> Corrects `means a lot for` → `means a lot to`.
    "harper.linters.MeansALotTo" = true;
    #> Fixes spacing inside `meanwhile`.
    "harper.linters.Meanwhile" = true;
    #> `Mercedes-Benz` hyphenation.
    "harper.linters.MercedesBenzHyphen" = true;
    #> Joins split words accidentally separated.
    "harper.linters.MergeWords" = true;
    #> Meta product names must be proper nouns.
    "harper.linters.MetaNames" = true;
    #> Microsoft product names must be proper nouns.
    "harper.linters.MicrosoftNames" = true;
    #> Fixes spacing inside `middleware`.
    "harper.linters.Middleware" = true;
    #> Flags missing determiners.
    "harper.linters.MissingDeterminer" = true;
    #> Flags missing prepositions.
    "harper.linters.MissingPreposition" = true;
    #> Adds missing `to` before infinitives.
    "harper.linters.MissingTo" = true;
    #> Ensures `misspell` is one word.
    "harper.linters.Misspell" = true;
    #> Fixes spacing inside `misunderstand`.
    "harper.linters.Misunderstand" = true;
    #> Fixes spacing inside `misunderstood`.
    "harper.linters.Misunderstood" = true;
    #> Fixes spacing inside `misuse`.
    "harper.linters.Misuse" = true;
    #> Fixes spacing inside `misused`.
    "harper.linters.Misused" = true;
    #> Corrects `mixed bad` → `mixed bag`.
    "harper.linters.MixedBag" = true;
    #> Flags missing `be` between modal and adjective.
    "harper.linters.ModalBeAdjective" = true;
    #> Detects `of` misused with modals.
    "harper.linters.ModalOf" = true;
    #> Detects `seen` → `seem`/`be` after modals.
    "harper.linters.ModalSeem" = true;
    #> Capitalises month names.
    "harper.linters.Months" = true;
    #> Advises `momentous`/`monumental`.
    "harper.linters.Monumentous" = true;
    #> Corrects `mute point` → `moot point`.
    "harper.linters.MootPoint" = true;
    #> Suggests inflected forms over `more + adjective`.
    #! default: false
    "harper.linters.MoreAdjective" = false;
    #> Flags redundant `more better` / `most best`.
    "harper.linters.MoreBetter" = true;
    #> Corrects `more than meets the eye` variants.
    "harper.linters.MoreThanMeetsTheEye" = true;
    #> Corrects `more that likely` → `more than likely`.
    "harper.linters.MoreThatLikely" = true;
    #> Corrects `most number` / `most amount`.
    "harper.linters.MostNumber" = true;
    #> Corrects `most of the times` → `most of the time`.
    "harper.linters.MostOfTheTimes" = true;
    #> Fixes spacing inside `multicore`.
    "harper.linters.Multicore" = true;
    #> Fixes spacing inside `multimedia`.
    "harper.linters.Multimedia" = true;
    #> Flags adjacent frequency adverbs.
    "harper.linters.MultipleFrequencyAdverbs" = true;
    #> Flags multiple sequential disparate pronouns.
    "harper.linters.MultipleSequentialPronouns" = true;
    #> Fixes spacing inside `multithreading`.
    "harper.linters.Multithreading" = true;
    #> Fixes typo `mu house` → `my house`.
    "harper.linters.MyHouse" = true;
    #> Fixes spacing inside `myself`.
    "harper.linters.Myself" = true;
    #> Corrects `nail on the coffin` → `nail in the coffin`.
    "harper.linters.NailInCoffin" = true;
    #> Corrects `nail on the head` variants.
    "harper.linters.NailOnTheHead" = true;
    #> Corrects wrong prepositions for `naked eye`.
    "harper.linters.NakedEye" = true;
    #> National capital names must be proper nouns.
    "harper.linters.NationalCapitals" = true;
    #> Corrects `ned help` → `need help`.
    "harper.linters.NeedHelp" = true;
    #> Flags `need to` + noun (missing verb).
    "harper.linters.NeedToNoun" = true;
    #> Neither-here-nor-there collection.
    "harper.linters.NeitherHereNorThere" = true;
    #> Corrects `nerve-racking` misspellings.
    "harper.linters.NerveRacking" = true;
    #> Suggests `nervous wreck`.
    "harper.linters.NervousWreck" = true;
    #> Expands initialism `NVM`.
    "harper.linters.NeverMind" = true;
    #> Corrects `Nobel Peace Prize` spelling.
    "harper.linters.NobelPeacePrize" = true;
    #> Fixes spacing inside `nobody`.
    "harper.linters.Nobody" = true;
    #> Blocks accidental French spaces.
    "harper.linters.NoFrenchSpaces" = true;
    #> Corrects `no harm, no foul` variants.
    "harper.linters.NoHarmNoFoul" = true;
    #> Corrects `not longer` → `no longer`.
    "harper.linters.NoLonger" = true;
    #> Detects `no longer` + subject pronoun.
    "harper.linters.NoLongerPronoun" = true;
    #> "No match for" idiom.
    "harper.linters.NoMatchFor" = true;
    #> Ensures `want`/`wants` after a nominal.
    "harper.linters.NominalWants" = true;
    #> Fixes spacing inside `nonetheless`.
    "harper.linters.Nonetheless" = true;
    #> Flags absence of Oxford comma in lists.
    #! default: false
    "harper.linters.NoOxfordComma" = false;
    #> Corrects pronoun/modal order after `nor`.
    "harper.linters.NorModalPronoun" = true;
    #> Notable place names must be proper nouns.
    "harper.linters.NotablePlaces" = true;
    #> Removes redundant `be` after `not`.
    "harper.linters.NotBeAfterNot" = true;
    #> Rewrites `not without a lack of` → `not for lack of`.
    "harper.linters.NotForLackOf" = true;
    #> Fixes spacing inside `nothing`.
    "harper.linters.Nothing" = true;
    #> Replaces `no in` → `not in`.
    "harper.linters.NotIn" = true;
    #> Not-long-after collection.
    "harper.linters.NotLongAfter" = true;
    #> Corrects `no only` → `not only` before `to be`.
    "harper.linters.NotOnly" = true;
    #> Corrects `not only it is` → `not only is it`.
    "harper.linters.NotOnlyInversion" = true;
    #> Corrects `no to` → `not to`.
    "harper.linters.NotTo" = true;
    #> Fixes spacing inside `notwithstanding`.
    "harper.linters.Notwithstanding" = true;
    #> Handles noun/verb confusions (`advice`/`advise`).
    "harper.linters.NounVerbConfusion" = true;
    #> Corrects `nowadays` misspellings.
    "harper.linters.Nowadays" = true;
    #> Fixes spacing inside `nowhere`.
    "harper.linters.Nowhere" = true;
    #> Corrects `now know as` → `now known as`.
    "harper.linters.NowKnownAs" = true;
    #> Corrects `now way` → `no way`.
    "harper.linters.NowWay" = true;
    #> Number suffixes are never capitalised.
    "harper.linters.NumberSuffixCapitalization" = true;
    #> Replaces hyphens and em dashes with en dashes in isolated numeric ranges such as `12–14`.
    "harper.linters.NumericRangeEnDash" = false; #! overridden
    #> Ensures valid prepositions with `obsess`.
    "harper.linters.ObsessPreposition" = true;
    #> Oceans and seas must be proper nouns.
    "harper.linters.OceansAndSeas" = true;
    #> Corrects `of course` variants (`of curse`, `off course`).
    "harper.linters.OfCourse" = true;
    #> Corrects `off-limit` → `off-limits`.
    "harper.linters.OffLimits" = true;
    #> Hyphenates `off-the-cuff`.
    "harper.linters.OffTheCuff" = true;
    #> Fixes spacing inside `oftentimes`.
    "harper.linters.Oftentimes" = true;
    #> Expands initialism `OMG`.
    "harper.linters.OhMyGod" = true;
    #> Corrects `ok` → `okay`.
    "harper.linters.OkToOkay" = true;
    #> Detects `oldest in the books` → `book`.
    "harper.linters.OldestInTheBook" = true;
    #> Corrects `old wise tale` → `old wives' tale`.
    "harper.linters.OldWivesTale" = true;
    #> On-a-daily-basis collection.
    "harper.linters.OnADailyBasis" = true;
    #> Corrects `once in a while` malapropisms.
    "harper.linters.OnceInAWhile" = true;
    #> Corrects `once a twice` → `once or twice`.
    "harper.linters.OnceOrTwice" = true;
    #> Flags `one in the same` → `one and the same`.
    "harper.linters.OneAndTheSame" = true;
    #> Corrects `one foul swoop` → `one fell swoop`.
    "harper.linters.OneFellSwoop" = true;
    #> Joins `one handed` / `two handed`.
    "harper.linters.OneHanded" = true;
    #> Corrects `one of the [singular]` → plural.
    "harper.linters.OneOfTheSingular" = true;
    #> Corrects `on one's own accord` → `of one's own accord`.
    "harper.linters.OnesOwnAccord" = true;
    #> Corrects `one's self` → `oneself`.
    "harper.linters.OnesSelf" = true;
    #> Prefers `at first glance`.
    "harper.linters.OnFirstGlance" = true;
    #> Corrects `in/at the floor` → `on the floor`.
    "harper.linters.OnFloor" = true;
    #> Corrects `on second though` → `on second thought`.
    "harper.linters.OnSecondThought" = true;
    #> Corrects `on a fence` → `on the fence`.
    "harper.linters.OnTheFence" = true;
    #> Expands initialism `OTOH`.
    "harper.linters.OnTheOtherHand" = true;
    #> Ensures `on the spur of the moment`.
    "harper.linters.OnTheSpurOfTheMoment" = true;
    #> Corrects `ontop of`/`in top of` → `on top of`.
    "harper.linters.OnTopOf" = true;
    #> Corrects compound words split by spaces.
    "harper.linters.OpenCompounds" = true;
    #> Corrects `open the light` → `turn on`/`switch on`.
    "harper.linters.OpenTheLight" = true;
    #> Ensures `operating system`.
    "harper.linters.OperatingSystem" = true;
    #> Matches canonical orthography casing.
    "harper.linters.OrthographicConsistency" = true;
    #> Detects `out to be` → `ought to be`.
    "harper.linters.OughtToBe" = true;
    #> Hyphenates `out-of-date` as adjective.
    "harper.linters.OutOfDate" = true;
    #> Corrects `out of sink` → `out of sync`.
    "harper.linters.OutOfSync" = true;
    #> Expands initialism `OOTB`.
    "harper.linters.OutOfTheBox" = true;
    #> `out (of) the window` idiom.
    "harper.linters.OutOfTheWindow" = true;
    #> Fixes spacing inside `overall`.
    "harper.linters.Overall" = true;
    #> Fixes spacing inside `overclocking`.
    "harper.linters.Overclocking" = true;
    #> Fixes spacing inside `overload`.
    "harper.linters.Overload" = true;
    #> Fixes spacing inside `overnight`.
    "harper.linters.Overnight" = true;
    #> Detects redundant `over` + `plus` with numbers.
    "harper.linters.OverPlus" = true;
    #> Joins `overtime` as compound noun in job-hours contexts.
    "harper.linters.OvertimeCompoundNoun" = true;
    #> The Oxford comma is one of the more controversial rules in common use today. Enabling this lint checks that there is a comma before `and`, `or`, or `nor` when listing out more than two ideas.
    "harper.linters.OxfordComma" = false; #! overridden
    #> Flags oxymoronic phrases.
    "harper.linters.Oxymorons" = true;
    #> Corrects `pale by comparison` variants.
    "harper.linters.PaleByComparison" = true;
    #> Corrects `part of speeches` → `parts of speech`.
    "harper.linters.PartsOfSpeech" = true;
    #> Corrects `passerbys` → `passersby`.
    "harper.linters.PassersBy" = true;
    #> Corrects `passtionate of` → `passionate about`.
    "harper.linters.PassionateAbout" = true;
    #> Hyphenates `password-protected`.
    "harper.linters.PasswordProtectedHyphen" = true;
    #> Corrects `payed` → `paid`.
    "harper.linters.Payed" = true;
    #> Corrects extraneous `for` in price/fee contexts.
    "harper.linters.PayForPrice" = true;
    #> Corrects `piece of mind` → `peace of mind`.
    "harper.linters.PeaceOfMind" = true;
    #> Corrects `pedal to the medal` → `pedal to the metal`.
    "harper.linters.PedalToTheMetal" = true;
    #> Corrects `peak behind the curtain` → `peek`.
    "harper.linters.PeekBehindTheCurtain" = true;
    #> Corrects `per se` misspellings.
    "harper.linters.PerSe" = true;
    #> Flags phrasal verbs used as compound nouns.
    "harper.linters.PhrasalVerbAsCompoundNoun" = true;
    #> Corrects `piggy bag` → `piggyback`.
    "harper.linters.Piggyback" = true;
    #> Corrects `peak`/`peek` → `pique` in `pique interest`.
    "harper.linters.PiqueInterest" = true;
    #> Corrects `play a factor`.
    "harper.linters.PlayAFactor" = true;
    #> Expands initialism `PTAL`.
    "harper.linters.PleaseTakeALook" = true;
    #> Fixes typo `pleas` → `please` before request verbs.
    "harper.linters.PleasRequestVerb" = true;
    #> Flags `'90s`-style apostrophe in decades.
    "harper.linters.PluralDecades" = true;
    #> Corrects pluralising the wrong noun in phrases.
    "harper.linters.PluralWrongWordOfPhrase" = true;
    #> Pocket Casts name must be proper noun.
    "harper.linters.PocketCastsNames" = true;
    #> Corrects `point of views` → `points of view`.
    "harper.linters.PointsOfView" = true;
    #> Checks `Port-au-Prince` spelling.
    "harper.linters.PortAuPrince" = true;
    #> Checks `Porto-Novo` spelling.
    "harper.linters.PortoNovo" = true;
    #> Apostrophe + `s` for possessive nouns.
    #! default: false
    "harper.linters.PossessiveNoun" = false;
    #> `your` before nouns (possessive).
    "harper.linters.PossessiveYour" = true;
    #> Joins `post-it note` → `Post-it`.
    "harper.linters.PostItNoteHyphen" = true;
    #> Fixes spacing inside `postpone`.
    "harper.linters.Postpone" = true;
    #> Corrects `preying mantis` → `praying mantis`.
    "harper.linters.PrayingMantis" = true;
    #> Prefers `pleaded` over `pled`.
    "harper.linters.PreferPleaded" = true;
    #> Prefers `pled` over `pleaded`.
    #! default: false
    "harper.linters.PreferPled" = false;
    #> Prefers `sneaked` over `snuck`.
    "harper.linters.PreferSneaked" = true;
    #> Prefers `snuck` over `sneaked`.
    #! default: false
    "harper.linters.PreferSnuck" = false;
    #> Corrects `principle` → `principal` before role nouns.
    "harper.linters.PrincipleToPrincipalRoleNoun" = true;
    #> Detects `<pronoun> have ...ing` errors.
    "harper.linters.ProgressiveNeedsBe" = true;
    #> Spots `r` for `are`/`you're` after pronouns.
    "harper.linters.PronounAre" = true;
    #> Handles pronoun-contraction errors.
    "harper.linters.PronounContraction" = true;
    #> Subject-verb agreement for `be`.
    "harper.linters.PronounInflectionBe" = true;
    #> Detects `new` (typo for `knew`) after pronouns.
    "harper.linters.PronounKnew" = true;
    #> Ensures pronouns agree with verbs.
    "harper.linters.PronounVerbAgreement" = true;
    #> Fixes spacing inside `proofread`.
    "harper.linters.Proofread" = true;
    #> Capitalises proper nouns.
    "harper.linters.ProperNouns" = true;
    #> Corrects `provocate` → `provoke`.
    "harper.linters.Provocate" = true;
    #> Adds missing `of` after `a couple`.
    "harper.linters.QuantifierNeedsOf" = true;
    #> Detects quantifier-numeral conflicts.
    "harper.linters.QuantifierNumeralConflict" = true;
    #> Corrects `quite many` → `quite a few`.
    "harper.linters.QuiteMany" = true;
    #> Distinguishes `quiet` from `quite`.
    "harper.linters.QuiteQuiet" = true;
    #> Checks quote mark spacing.
    "harper.linters.QuoteSpacing" = true;
    #> Hyphenates `rainbow-colored` before nouns.
    "harper.linters.RainbowColoredHyphen" = true;
    #> Corrects `rally` → `really` in `be ...ing` constructions.
    "harper.linters.RallyToReally" = true;
    #> Hyphenates `rapid-fire`.
    "harper.linters.RapidFire" = true;
    #> Ensures `read`/`write` forms are consistent.
    "harper.linters.ReadsAndWrites" = true;
    #> Expands `really` (collection).
    "harper.linters.Really" = true;
    #> Ensures `real trouper` (not `trooper`).
    "harper.linters.RealTrouper" = true;
    #> Corrects `reason of doing` → `reason for doing`.
    "harper.linters.ReasonForDoing" = true;
    #> Flags redundant acronyms (`ATM machine`).
    "harper.linters.RedundantAcronyms" = true;
    #> Detects redundant additive adverbs.
    "harper.linters.RedundantAdditiveAdverbs" = true;
    #> Detects `almost` + `nearly` together.
    "harper.linters.RedundantAlmostNearly" = true;
    #> Flags redundant `first` with order-implying verbs.
    "harper.linters.RedundantFirsts" = true;
    #> Flags redundant `if`/`correctly` with `IIRC`.
    "harper.linters.RedundantIIRC" = true;
    #> `Pretty decent` → `decent`.
    "harper.linters.RedundantPretty" = true;
    #> Detects `increasingly more/less`.
    "harper.linters.RedundantProgressiveComparative" = true;
    #> Detects redundant `self-` with reflexive pronouns.
    "harper.linters.RedundantSelf" = true;
    #> Simplifies `most optimal` → `optimal`.
    "harper.linters.RedundantSuperlatives" = true;
    #> Collapses `that that` → `that`.
    "harper.linters.RedundantThat" = true;
    #> Fixes spacing inside `regardless`.
    "harper.linters.Regardless" = true;
    #> Distinguishes `regimen` (routine) from `regiment`.
    "harper.linters.RegimenRegiment" = true;
    #> Flags regionalisms.
    "harper.linters.Regionalisms" = true;
    #> Replaces regular inflections of irregular words.
    "harper.linters.RegularIrregulars" = true;
    #> Corrects `relay on` → `rely on`.
    "harper.linters.RelayOnForRely" = true;
    #> Flags non-homograph repeated words.
    "harper.linters.RepeatedWords" = true;
    #> Flags noun `response` where verb `respond` fits.
    "harper.linters.Respond" = true;
    #> Corrects `responsibility of` → `responsibility for`.
    "harper.linters.ResponsibilityFor" = true;
    #> Corrects `responsible about` → `responsible for`.
    "harper.linters.ResponsibleFor" = true;
    #> Corrects `reversed engineer` → `reverse engineer`.
    "harper.linters.ReverseEngineer" = true;
    #> Corrects `ripe with` → `rife with`.
    "harper.linters.RifeWith" = true;
    #> Hyphenates `right-click`.
    "harper.linters.RightClick" = true;
    #> Corrects `rise the question` → `raise the question`.
    "harper.linters.RiseTheQuestion" = true;
    #> Corrects `rise the ranks` variants.
    "harper.linters.RiseTheRanks" = true;
    #> Distinguishes `roadmap` from `road map`.
    "harper.linters.RoadMap" = true;
    #> Distinguishes `rogue` from `rouge`.
    "harper.linters.RogueRouge" = true;
    #> Hyphenates `roller-skated`.
    "harper.linters.RollerSkated" = true;
    #> Corrects `rule of thumbs` → `rules of thumb`.
    "harper.linters.RulesOfThumb" = true;
    #> Corrects `run into problems`/`trouble` variants.
    "harper.linters.RunIntoProblemsOrTrouble" = true;
    #> Distinguishes `safe` from `save` after modals.
    "harper.linters.SafeToSave" = true;
    #> Corrects `same then` → `same as`.
    "harper.linters.SameAs" = true;
    #> Corrects `save to <verb>` → `safe to <verb>`.
    "harper.linters.SaveToSafe" = true;
    #> Fixes `scandally clad` → `scantily clad`.
    "harper.linters.ScantilyClad" = true;
    #> Corrects `scape goat` → `scapegoat`.
    "harper.linters.ScapeGoat" = true;
    #> Corrects `seam` → `seem` (verb).
    "harper.linters.SeamToSeem" = true;
    #> Corrects `seize control over` → `of`.
    "harper.linters.SeizeControlOf" = true;
    #> Replaces `send an email to` → `email`.
    "harper.linters.SendAnEmailTo" = true;
    #> The opening word of a sentence should almost always be capitalized.
    "harper.linters.SentenceCapitalization" = false; #! overridden
    #> Corrects `set up a bad example` → `set a bad example`.
    "harper.linters.SetABadExample" = true;
    #> Corrects `shoot oneself in the foot` variants.
    "harper.linters.ShootOneselfInTheFoot" = true;
    #> Fixes spacing inside `shortcoming`.
    "harper.linters.Shortcoming" = true;
    #> Fixes spacing inside `shortcomings`.
    "harper.linters.Shortcomings" = true;
    #> Corrects `show case` → `showcase`.
    "harper.linters.ShowCase" = true;
    #> Keeps `shutdown` noun vs `shut down` verb.
    "harper.linters.ShutdownVerb" = true;
    #> Corrects redundant `side tangent`.
    "harper.linters.SideTangent" = true;
    #> Pairs `similar` with `to`.
    "harper.linters.SimilarLike" = true;
    #> Corrects `simply grammatical` → `simple grammatical`.
    "harper.linters.SimpleGrammatical" = true;
    #> Uses past participle after auxiliaries.
    "harper.linters.SimplePastToPastParticiple" = true;
    #> Detects `since` with a duration.
    "harper.linters.SinceDuration" = true;
    #> Removes duplicate `be` inflections.
    "harper.linters.SingleBe" = true;
    #> Fixes spacing inside `skyrocket`.
    "harper.linters.Skyrocket" = true;
    #> Corrects `slippy slope` → `slippery slope`.
    "harper.linters.SlipperySlope" = true;
    #> Changes `sneaky suspicion` → `sneaking suspicion`.
    "harper.linters.SneakingSuspicion" = true;
    #> Corrects `sneak peak` → `sneak peek`.
    "harper.linters.SneakPeekPreview" = true;
    #> Fixes spacing inside `somebody`.
    "harper.linters.Somebody" = true;
    #> Corrects `somebody else's` positioning.
    "harper.linters.SomebodyElses" = true;
    #> Fixes spacing inside `somehow`.
    "harper.linters.Somehow" = true;
    #> Prefers `some of the` before definite articles.
    "harper.linters.SomeOfThe" = true;
    #> Fixes spacing inside `someone`.
    "harper.linters.Someone" = true;
    #> Corrects `somethings` → `something's`/`something is`.
    "harper.linters.SomethingIs" = true;
    #> Prefers `something of a` over `somewhat of a`.
    "harper.linters.SomewhatSomething" = true;
    #> Fixes spacing inside `somewhere`.
    "harper.linters.Somewhere" = true;
    #> Flags redundant article before `some`.
    "harper.linters.SomeWithoutArticle" = true;
    #> Corrects `sooner than later` variants.
    "harper.linters.SoonerOrLater" = true;
    #> Hyphenates `soon-to-be` before nouns.
    "harper.linters.SoonToBe" = true;
    #> Corrects `sort after` → `sought after`.
    "harper.linters.SoughtAfter" = true;
    #> Collapses double spaces.
    "harper.linters.Spaces" = true;
    #> Changes `spacial attention` → `special attention`.
    "harper.linters.SpecialAttention" = true;
    #> Spell checker.
    "harper.linters.SpellCheck" = true;
    #> Prefers numbers < 10 spelled out.
    #! default: false
    "harper.linters.SpelledNumbers" = false;
    #> Corrects `spinal chord` → `spinal cord`.
    "harper.linters.SpinalChord" = true;
    #> Joins split compound words.
    "harper.linters.SplitWords" = true;
    #> Suggests `starving` for `very hungry`.
    "harper.linters.Starving" = true;
    #> Corrects `state of art` → `state of the art`.
    "harper.linters.StateOfTheArt" = true;
    #> Corrects `statue of limitations` → `statute of limitations`.
    "harper.linters.StatuteOfLimitations" = true;
    #> Fixes spacing inside `straightforward`.
    "harper.linters.Straightforward" = true;
    #> Fixes `strike a cord` → `strike a chord`.
    "harper.linters.StrikeChord" = true;
    #> Corrects `strike of genius` → `stroke of genius`.
    "harper.linters.StrikeOfGenius" = true;
    #> Corrects `strike of luck` → `stroke of luck`.
    "harper.linters.StrikeOfLuck" = true;
    #> Prefers `subject`/`object pronoun`.
    "harper.linters.SubjectAndObjectPronoun" = true;
    #> Corrects `me and X` → `X and I`.
    "harper.linters.SubjectPronoun" = true;
    #> Uses subjunctive `were` in counterfactuals.
    "harper.linters.SubjunctiveWasToWere" = true;
    #> Corrects `such shame` → `such a shame`.
    "harper.linters.SuchShame" = true;
    #> Corrects `suffice to say` → `suffice it to say`.
    "harper.linters.SufficeItToSay" = true;
    #> Distinguishes `summary` from `summery`.
    "harper.linters.SummarySummery" = true;
    #> Corrects `suppose to` → `supposed to`.
    "harper.linters.SupposedTo" = true;
    #> Suggests `surreality` for `surrealness`.
    "harper.linters.Surreality" = true;
    #> Corrects `take a look to` → `take a look at`.
    "harper.linters.TakeALookTo" = true;
    #> Corrects `take care about` → `take care of`.
    "harper.linters.TakeCareOf" = true;
    #> Corrects `take control over` → `take control of`.
    "harper.linters.TakeControlOf" = true;
    #> Corrects `take it personal` → `take it personally`.
    "harper.linters.TakeItPersonally" = true;
    #> Prefers `take`/`swallow` for medicine (not `eat`).
    "harper.linters.TakeMedicine" = true;
    #> Corrects `take pride of` → `take pride in`.
    "harper.linters.TakePrideIn" = true;
    #> Expands initialism `TTYL`.
    "harper.linters.TalkToYouLater" = true;
    #> Fixes spacing inside `tenfold`.
    "harper.linters.Tenfold" = true;
    #> Adds missing `a` before `thanks lot`.
    "harper.linters.ThanksALot" = true;
    #> Corrects `the challenged` → `that challenged`.
    "harper.linters.ThatChallenged" = true;
    #> Corrects `that` → `than` in comparisons.
    "harper.linters.ThatThan" = true;
    #> Fixes `the this` → `that this`.
    "harper.linters.ThatThis" = true;
    #> Prefers `that which`.
    "harper.linters.ThatWhich" = true;
    #> Fixes common `the` misspellings.
    "harper.linters.The" = true;
    #> Corrects `the another`.
    "harper.linters.TheAnother" = true;
    #> Corrects `the different(s) between` → `the difference between`.
    "harper.linters.TheDifferenceBetween" = true;
    #> Corrects `the entire of` → `the entirety of`.
    "harper.linters.TheEntiretyOf" = true;
    #> Removes extra `the` in `the how`/`the why`.
    "harper.linters.TheHowWhy" = true;
    #> Corrects `their` → `there`.
    "harper.linters.TheirToThere" = true;
    #> Corrects `their` → `they're`.
    "harper.linters.TheirToTheyre" = true;
    #> Corrects `in the last days` → `in the last few days`.
    "harper.linters.TheLastDays" = true;
    #> Corrects `their self` → `themself`/`themselves`.
    "harper.linters.Themself" = true;
    #> Flags `the` + possessive determiner.
    "harper.linters.TheMy" = true;
    #> Distinguishes `then` from `than`.
    "harper.linters.ThenThan" = true;
    #> Corrects `the point for` → `the point of`.
    "harper.linters.ThePointFor" = true;
    #> Flags redundant `the` + possessive proper noun.
    "harper.linters.TheProperNounPossessive" = true;
    #> Fixes spacing inside `there`.
    "harper.linters.There" = true;
    #> Joins `there after` → `thereafter`.
    "harper.linters.ThereAfterCompound" = true;
    #> Fixes spacing inside `therefore`.
    "harper.linters.Therefore" = true;
    #> Flags `there in`/`there-in` → `therein`.
    "harper.linters.Therein" = true;
    #> Subject-verb agreement in `there is`.
    "harper.linters.ThereIsAgreement" = true;
    #> Inserts `is` in `if there a ...`.
    "harper.linters.ThereMissingIsClause" = true;
    #> Corrects `there own`/`they're own` → `their own`.
    "harper.linters.ThereOwn" = true;
    #> Replaces `their's` → `there's`.
    "harper.linters.Theres" = true;
    #> Corrects `there` → `their`.
    "harper.linters.ThereToTheir" = true;
    #> Fixes spacing inside `thereupon`.
    "harper.linters.Thereupon" = true;
    #> Corrects `theses` → `these`.
    "harper.linters.ThesesThese" = true;
    #> Corrects `the the` → `that the` or `the`.
    "harper.linters.TheTheToThatThe" = true;
    #> Fixes `the whether` → `the weather`.
    "harper.linters.TheWhetherWeather" = true;
    #> Handles `they're` confusions.
    "harper.linters.TheyreConfusions" = true;
    #> Corrects `they're` → `their`.
    "harper.linters.TheyreToTheir" = true;
    #> Converts `they` → `them` as object.
    "harper.linters.TheyToThem" = true;
    #> Fixes `thieve` → `thief` in noun phrases.
    "harper.linters.ThieveNoun" = true;
    #> Corrects `thing` → `think`.
    "harper.linters.ThingThink" = true;
    #> Fixes `know off`/`thought off` → `of`.
    "harper.linters.ThinkKnowOff" = true;
    #> Ensures number agreement in `this/these type(s) of thing(s)`.
    "harper.linters.ThisTypeOfThing" = true;
    #> Corrects `though` → `thought`.
    "harper.linters.ThoughThought" = true;
    #> Changes `though process` → `thought process`.
    "harper.linters.ThoughtProcess" = true;
    #> Normalises `threat` → `threaten` after modals.
    "harper.linters.ThreatenVerb" = true;
    #> Corrects `thrive off` → `thrive on`.
    "harper.linters.ThriveOn" = true;
    #> Fixes `through away` → `throw away`/`threw away`.
    "harper.linters.ThrowAway" = true;
    #> Corrects `throw the baby out with the bathwater` variants.
    "harper.linters.ThrowBabyWithBathwater" = true;
    #> Checks `throw rubbish` → `throw away`.
    "harper.linters.ThrowRubbish" = true;
    #> Corrects `ticking time clock` → `ticking time bomb`/`ticking clock`.
    "harper.linters.TickingTimeClock" = true;
    #> Corrects Indian English `till date` → `to date` (non-IN dialect).
    "harper.linters.TillDate" = true;
    #> Flags duplicated `to` around adverbs.
    "harper.linters.ToAdverb" = true;
    #> Prefers `to back out` (verb) over `to backout`.
    "harper.linters.ToBackOut" = true;
    #> Expands initialism `TBH`.
    "harper.linters.ToBeHonest" = true;
    #> Hyphenates `to-do`.
    "harper.linters.ToDoHyphen" = true;
    #> Corrects `through great lengths` → `to great lengths`.
    "harper.linters.ToGreatLengths" = true;
    #> Corrects `to lose too loose` confusions.
    "harper.linters.ToLoseTooLoose" = true;
    #> Suggests `tomorrow's` as attributive modifier.
    "harper.linters.TomorrowPossessiveModifier" = true;
    #> Corrects `tongue in cheek` idiom.
    "harper.linters.TongueInCheek" = true;
    #> Corrects `too` → `to`.
    "harper.linters.TooTo" = true;
    #> Corrects `in some degree` → `to some degree`.
    "harper.linters.ToSomeDegree" = true;
    #> Flags `tote`/`tout` confusion.
    "harper.linters.ToteTout" = true;
    #> Corrects `to the manor born` → `to the manner born`.
    "harper.linters.ToTheMannerBorn" = true;
    #> Fixes `to to` → remove or `to do`.
    "harper.linters.ToTo" = true;
    #> Corrects `to` → `too` in common idioms.
    "harper.linters.ToTooIdioms" = true;
    #> Handles `to`/`too`/`two` homophones.
    "harper.linters.ToTwoToo" = true;
    #> Suggests `tourist`/`tourism`/`touristy` over `touristic`.
    "harper.linters.Touristic" = true;
    #> Removes redundant `to` before `towards`.
    "harper.linters.Towards" = true;
    #> Fixes `to worried about`.
    "harper.linters.ToWorryAbout" = true;
    #> Fixes spacing inside `tradeoff`.
    "harper.linters.Tradeoff" = true;
    #> Fixes spaced one character too early/late.
    "harper.linters.TransposedSpace" = true;
    #> Corrects `trail and error` → `trial and error`.
    "harper.linters.TrialAndError" = true;
    #> Normalises `true to <possessive>` phrasing.
    "harper.linters.TrueToWord" = true;
    #> Flags redundant `truth to the fact`.
    "harper.linters.TruthToTheFact" = true;
    #> Corrects `try one's hands at` → `hand`.
    "harper.linters.TryOnesHandAt" = true;
    #> Corrects `try out one's luck` → `try one's luck`.
    "harper.linters.TryOnesLuck" = true;
    #> Corrects `tuff` → `tough` in common phrases.
    "harper.linters.TuffEnough" = true;
    #> Tumblr product names must be proper nouns.
    "harper.linters.TumblrNames" = true;
    #> Fixes `turn if off` → `turn it off`.
    "harper.linters.TurnItOff" = true;
    #> Requires closed quotes.
    "harper.linters.UnclosedQuotes" = true;
    #> Fixes spacing inside `underclock`.
    "harper.linters.Underclock" = true;
    #> Corrects `underneath of`.
    "harper.linters.UnderneathOf" = true;
    #> Organisation names must be proper nouns.
    "harper.linters.UnitedOrganizations" = true;
    #> Corrects `unless if`.
    "harper.linters.Unless" = true;
    #> Flags deprecated place names.
    "harper.linters.UpdatePlaceNames" = true;
    #> Fixes spacing inside `upset`.
    "harper.linters.Upset" = true;
    #> Fixes spacing inside `upward`.
    "harper.linters.Upward" = true;
    #> Replaces `...` with `…`.
    "harper.linters.UseEllipsisCharacter" = true;
    #> Prefers title case in headings.
    "harper.linters.UseTitleCase" = true;
    #> Corrects `use to` → `used to` (accustomed).
    "harper.linters.UseToUsedTo" = true;
    #> US university names must be proper nouns.
    "harper.linters.USUniversities" = true;
    #> Corrects adverb after article where adjective fits.
    "harper.linters.VerbToAdjective" = true;
    #> Corrects `verse` (as verb) to standard.
    "harper.linters.VerseAsVerb" = true;
    #> Flags `very known` → `well-known`.
    "harper.linters.VeryKnown" = true;
    #> Corrects `very less` (non-native idiom).
    "harper.linters.VeryLess" = true;
    #> Flags redundant `very much so`.
    "harper.linters.VeryMuchSo" = true;
    #> Flags `very unique`/`pretty unique`.
    "harper.linters.VeryUnique" = true;
    #> No hyphen in `vice versa`.
    "harper.linters.ViceVersa" = true;
    #> Corrects `vicious/virtuous circle` variants.
    "harper.linters.ViciousCircle" = true;
    #> Distinguishes `vicious/virtuous circle` from `cycle`.
    #! default: false
    "harper.linters.ViciousCircleOrCycle" = false;
    #> Distinguishes `vicious/virtuous cycle` variants.
    #! default: false
    "harper.linters.ViciousCycle" = false;
    #> Corrects `waste` → `waist` (body part).
    "harper.linters.WaistWaste" = true;
    #> Corrects `want be` → `won't be`/`want to be`.
    "harper.linters.WantBe" = true;
    #> Corrects `was aloud` → `was allowed`.
    "harper.linters.WasAloud" = true;
    #> Rewrites `was comprised of`.
    "harper.linters.WasComprisedOf" = true;
    #> Fixes `wavefunction` → `wave function`.
    "harper.linters.WaveFunction" = true;
    #> Replaces `way to` → `way too` + adjective.
    "harper.linters.WayTooAdjective" = true;
    #> Corrects `scrapping the web` → `scraping`.
    "harper.linters.WebScraping" = true;
    #> Hyphenates `well-being`.
    "harper.linters.WellBeing" = true;
    #> Replaces `good-educated` → `well-educated`.
    "harper.linters.WellEducated" = true;
    #> Prefers `well-kept` over `highly-kept`.
    "harper.linters.WellKept" = true;
    #> Corrects `went ahead and <present tense>`.
    "harper.linters.WentAheadAndAgreement" = true;
    #> Distinguishes `were` from `where`.
    "harper.linters.WereWhere" = true;
    #> Corrects `where as` → `whereas`.
    "harper.linters.Whereas" = true;
    #> Fixes spacing inside `whereupon`.
    "harper.linters.Whereupon" = true;
    #> Ensures `whet your appetite`.
    "harper.linters.WhetYourAppetite" = true;
    #> Collapses `whole entire` → `whole`/`entire`.
    "harper.linters.WholeEntire" = true;
    #> Detects `whom` used as subject.
    "harper.linters.WhomSubjectOfVerb" = true;
    #> Corrects `wide accepted` → `widely accepted`.
    "harper.linters.WidelyAccepted" = true;
    #> Fixes spacing inside `widespread`.
    "harper.linters.Widespread" = true;
    #> Corrects `will contain` (base form required).
    "harper.linters.WillContain" = true;
    #> Corrects `will gonna`/`will going to` → `will`.
    "harper.linters.WillGonna" = true;
    #> Flags wrong verb forms after `will`/`shall`.
    "harper.linters.WillNonLemma" = true;
    #> Corrects `win price`/`prise` → `win prize`.
    "harper.linters.WinPrize" = true;
    #> Corrects `wish can` → `wish could`.
    "harper.linters.WishCould" = true;
    #> Corrects `with open arms` variants.
    "harper.linters.WithOpenArms" = true;
    #> Fixes spacing inside `without`.
    "harper.linters.Without" = true;
    #> Collapses `without out` → `without`.
    "harper.linters.WithoutOut" = true;
    #> Fixes `wok` → `work` typo.
    "harper.linters.WokVerbTypo" = true;
    #> Ensures `WordPress.com` capitalisation.
    "harper.linters.WordPressDotcom" = true;
    #> Fixes spacing inside `worldwide`.
    "harper.linters.Worldwide" = true;
    #> Distinguishes `worse` from `worst`.
    "harper.linters.WorseOrWorst" = true;
    #> Hyphenates `worst-case scenario`.
    "harper.linters.WorstCaseScenario" = true;
    #> Corrects `worth to <verb>` → `worth <verb>ing`.
    "harper.linters.WorthToDo" = true;
    #> Fixes spacing inside `worthwhile`.
    "harper.linters.Whilewhile" = true;
    #> Corrects `would/could have never`.
    "harper.linters.WouldNeverHave" = true;
    #> Corrects `wreck havoc` → `wreak havoc`.
    "harper.linters.WreakHavoc" = true;
    #> Corrects semicolons, acute accents, backticks for apostrophes.
    "harper.linters.WrongApostrophe" = true;
    #> Flags unknown negative words.
    "harper.linters.WrongNegative" = true;
    #> Corrects `by wrote` → `by rote`.
    "harper.linters.WroteToRote" = true;
    #> Fixes `rod iron`/`rot iron` → `wrought iron`.
    "harper.linters.WroughtIron" = true;
    #> Corrects `yea` → `yeah`.
    "harper.linters.YeaToYeah" = true;
    #> Corrects `yeh` → `yeah`.
    "harper.linters.YehToYeah" = true;
    #> Corrects `your out` → `you're out`.
    "harper.linters.YourOutClauseAgreement" = true;
    #> Corrects `your <adjective>` → `you're <adjective>`.
    "harper.linters.YourPredicateAdjective" = true;
    #> Fixes spacing inside `yourself`.
    "harper.linters.Yourself" = true;
  };
}