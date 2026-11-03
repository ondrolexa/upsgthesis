%%% upsgthesis.cls
%%% Charles University, Faculty of Science -- bachelor's/master's thesis class.
%%%
%%% Single source of truth for structure, margins, title page, and packages.
%%% Thesis language is selected as a class option:
%%%   \documentclass[english]{upsgthesis}
%%%   \documentclass[czech]{upsgthesis}
%%% Option `nocaseconv` disables biblatex-apa's sentence-case conversion of
%%% bibliography titles (titles then print exactly as entered in the .bib);
%%% off by default, i.e. APA sentence case is applied.
%%% Option `markoverfull` marks overfull lines with a black bar in the
%%% margin (a drafting aid; off by default so the final PDF stays clean).
%%% All other options (12pt, a4paper, twoside, openright, ...) are passed
%%% through to the underlying `report` class unchanged.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{upsgthesis}[2026/07/22 v1.0 Charles University PrF thesis class]

\newif\ifupsgCzech
\DeclareOption{english}{\upsgCzechfalse}
\DeclareOption{czech}{\upsgCzechtrue}
\newif\ifupsgNoCaseConv
\DeclareOption{nocaseconv}{\upsgNoCaseConvtrue}
\newif\ifupsgMarkOverfull
\DeclareOption{markoverfull}{\upsgMarkOverfulltrue}
%% Everything else goes to `report`. Options that report doesn't know are
%% still passed on (as global options they may be meant for a package, e.g.
%% xcolor's `dvipsnames`), but a warning is issued so that a typo such as
%% `czesh` doesn't silently produce an English thesis.
\def\upsgReportOptions{10pt,11pt,12pt,a4paper,a5paper,b5paper,letterpaper,%
  legalpaper,executivepaper,landscape,oneside,twoside,openright,openany,%
  onecolumn,twocolumn,titlepage,notitlepage,leqno,fleqn,openbib,draft,final}
\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{report}%
  \def\upsgIsKnown{0}%
  \@for\upsgOpt:=\upsgReportOptions\do{%
    \ifx\upsgOpt\CurrentOption\def\upsgIsKnown{1}\fi}%
  \if0\upsgIsKnown
    \ClassWarningNoLine{upsgthesis}{Unknown class option `\CurrentOption'
      (passed on to report/packages). Thesis language options are `english'
      and `czech'}%
  \fi}
\ExecuteOptions{english}
\ProcessOptions\relax
\LoadClass{report}

\RequirePackage{etoolbox}

%% Page margins and \openright behaviour depending on the 'twoside' class option.
\RequirePackage[top=25mm,bottom=25mm,right=20mm,left=20mm,head=12.5mm,foot=12.5mm]{geometry}
\makeatletter
\if@twoside
  \geometry{bindingoffset=15mm}% reserve extra space for binding
  \let\openright=\cleardoublepage
\else
  \let\openright=\clearpage
\fi
\makeatother

%% tocloft must be loaded before hyperref/pdfx, otherwise hyperref redefines
%% \@starttoc first and tocloft's own attempt to redefine it is skipped
%% (warning "tocloft bailing out"), silently dropping part of its setup.
\RequirePackage{tocloft}
\setlength\cftparskip{0pt}
\setlength\cftbeforechapskip{1.5ex}
\setlength\cftfigindent{0pt}
\setlength\cfttabindent{0pt}
\setlength\cftbeforeloftitleskip{0pt}
\setlength\cftbeforelottitleskip{0pt}
\setlength\cftbeforetoctitleskip{0pt}
\renewcommand{\cftlottitlefont}{\Huge\bfseries\sffamily}
\renewcommand{\cftloftitlefont}{\Huge\bfseries\sffamily}
\renewcommand{\cfttoctitlefont}{\Huge\bfseries\sffamily}

%% pdfx loads and configures hyperref itself (with the options PDF/A
%% requires); a manual \usepackage{hyperref} beforehand is redundant and
%% just clashes with pdfx's own options (see warning "Option 'pdftex' has
%% already been used"). Any extra option (e.g. hidelinks) is set via
%% \hypersetup after pdfx is loaded.
%% xcolor is loaded before pdfx: otherwise pdfx loads it with the obsolete
%% `hyperref' option (warning "Package option `hyperref' is obsolete").
\RequirePackage[rgb]{xcolor}    % colour typesetting
\RequirePackage[a-2u]{pdfx}     % the resulting PDF will conform to the PDF/A-2u standard
\hypersetup{hidelinks}   % (`unicode' and `pdfa' are already set by pdfx)

%% Language: Czech or English typesetting, Latin Modern fonts, proper font encoding.
\ifupsgCzech
  \RequirePackage[czech]{babel}
\else
  \RequirePackage[english]{babel}
\fi
%% Fonts and encoding depend on the engine (detected via iftex):
%%  - pdfLaTeX: 8-bit engine -> Type 1 Latin Modern in T1 encoding, UTF-8
%%    input via inputenc, Inconsolata via the zi4 package.
%%  - XeLaTeX/LuaLaTeX: Unicode engines -> OpenType fonts via fontspec
%%    (TU encoding, native UTF-8); fontenc/inputenc must NOT be loaded here.
%%    Same typefaces (Latin Modern + Inconsolata), so output looks the same.
\RequirePackage{iftex}
\ifPDFTeX
  \RequirePackage{lmodern}
  \RequirePackage[T1]{fontenc}
  \RequirePackage{zi4}          % Inconsolata: a more condensed, modern monospace font for code
  \RequirePackage{textcomp}
  \RequirePackage[utf8]{inputenc}
\else
  % lmodern first so that math (still set in legacy 8-bit fonts, OML/OMS)
  % uses Latin Modern as under pdfLaTeX; fontspec then overrides text fonts.
  \RequirePackage{lmodern}
  \RequirePackage{fontspec}
  % Fonts are selected by file name (shipped with TeX Live), not by system
  % font name, so they are found even when not installed in fontconfig.
  \setmainfont{lmroman10}[Extension=.otf, UprightFont=*-regular,
    BoldFont=*-bold, ItalicFont=*-italic, BoldItalicFont=*-bolditalic]
  \setsansfont{lmsans10}[Extension=.otf, UprightFont=*-regular,
    BoldFont=*-bold, ItalicFont=*-oblique, BoldItalicFont=*-boldoblique]
  \setmonofont{Inconsolatazi4}[Extension=.otf, UprightFont=*-Regular,
    BoldFont=*-Bold, Scale=MatchLowercase]
  % babel-czech defines its quote commands (\clqq etc., used by csquotes'
  % Czech style) only for OT1/T1; under TU they would fall back to OT1 and
  % silently pull in Computer Modern glyphs. Provide TU versions mirroring
  % babel-czech's own T1 definitions (\Provide..., so a future babel-czech
  % that defines them for TU itself takes precedence instead of clashing).
  \makeatletter
  \ProvideTextCommand{\clqq}{TU}{\kern.1em\quotedblbase\kern-.0158em\relax}
  \ProvideTextCommand{\crqq}{TU}{\save@sf@q{\nobreak\kern.06em\textquotedblleft\kern.024em}}
  \ProvideTextCommand{\clq}{TU}{\quotesinglbase\kern-.0428em\relax}
  \ProvideTextCommand{\crq}{TU}{\save@sf@q{\nobreak\textquoteleft\kern.17em}}
  \makeatother
\fi
\RequirePackage{csquotes}
%% Date on the declaration page (Czech "3. 11. 2026", English
%% "3 November 2026"). Defined directly rather than via the obsolete
%% `datetime' package, whose \newdateformat also changed \today globally.
\ifupsgCzech
  \newcommand{\upsgDate}{\number\day.~\number\month.~\number\year}
\else
  \newcommand{\upsgDate}{\number\day~\ifcase\month\or January\or February\or
    March\or April\or May\or June\or July\or August\or September\or
    October\or November\or December\fi~\number\year}
\fi

%%% Settings for using a standalone bibliography database.
\ifupsgCzech
  \def\upsgSortlocale{cs_CZ}
\else
  \def\upsgSortlocale{en_US}
\fi
\RequirePackage[
   backend=biber
   ,style=apa
%  ,style=authoryear
%  ,style=iso-authoryear
%  ,style=iso-numeric
  ,sortlocale=\upsgSortlocale
  ,bibencoding=UTF8
  ,giveninits=true
  ,uniquename=init
  ,doi=false
  ,isbn=false
  ,url=false
  ,eprint=false
  %,block=ragged
]{biblatex}
\ifupsgCzech
  % biblatex-apa ships no Czech localisation file by default; czech-apa.lbx
  % (community-contributed) is bundled alongside this class, so map babel's
  % 'czech' language to it explicitly.
  \DeclareLanguageMapping{czech}{czech-apa}
\fi
% Sort surname before given-name initial
\DeclareNameAlias{sortname}{family-given}
% Page numbers without a prefix
\DeclareFieldFormat{pages}{#1}
% With the `nocaseconv` class option, disable biblatex-apa's sentence-case
% conversion of titles entirely, so titles print exactly as entered in the .bib
\ifupsgNoCaseConv
  \DeclareFieldFormat{apacase}{#1}
\fi
\let\cite\parencite
\def\upsgBibFile{bibliography.bib}
\newcommand{\Bibliography}[1]{\renewcommand{\upsgBibFile}{#1}}
\AtEndPreamble{\addbibresource{\upsgBibFile}}

%%% Other useful packages (part of common LaTeX distributions)
\RequirePackage{amsmath}        % extensions for typesetting mathematics
\RequirePackage{amsfonts}       % mathematical fonts
\RequirePackage{amsthm}         % typesetting of theorems, definitions, etc.
\RequirePackage{bm}             % bold symbols (\bm command)
\RequirePackage{graphicx}       % including images
\RequirePackage{fancyhdr}       % more convenient header/footer configuration
\RequirePackage{icomma}         % smart comma in math mode
\RequirePackage{dcolumn}        % better column alignment in tables
\RequirePackage{booktabs}       % nicer horizontal rules in tables
\RequirePackage{siunitx}        % physical units typesetting
\DeclareSIUnit\Ma{Ma}
\DeclareSIUnit\Ga{Ga}
\DeclareSIUnit\yr{yr}
\sisetup{uncertainty-mode = separate} % 337.13 ± 0.37 rather than 337.13(37)
\DeclareSIUnit\annum{a}
\DeclareSIUnit\kbar{kbar}
\DeclareSIUnit\wtpercent{wt\%}
\DeclareSIUnit\ppm{ppm}
\ifupsgCzech
  \sisetup{output-decimal-marker = {,}}
  % siunitx has no Czech translations: without these it prints
  % "1,8 Ga to (numerical range) 2,7 Ga" etc.
  \sisetup{
    range-phrase = {--}, range-units = single,
    list-pair-separator = {~a~}, list-final-separator = {~a~},
    list-separator = {,~},
    product-symbol = {\times},
  }
\else
  \sisetup{output-decimal-marker = {.}}
\fi
\RequirePackage{multicol}       % working with multiple columns on a page
\RequirePackage[font={small,it}]{caption}
\RequirePackage{enumitem}
\setlist[itemize]{noitemsep, topsep=0pt, partopsep=0pt}
\setlist[enumerate]{noitemsep, topsep=0pt, partopsep=0pt}
\setlist[description]{noitemsep, topsep=0pt, partopsep=0pt}

% paragraph styling
\parindent=0pt
\parskip=11pt
% rigid \parskip + twoside (\flushbottom) leads to "Underfull \vbox while
% \output is active" on pages next to floats; let page bottoms vary instead
\raggedbottom

% discourage (not forbid -- that would need 10000) widows and orphans:
% single-line paragraph starts/ends across a page break
\clubpenalty=1000
\widowpenalty=1000
\displaywidowpenalty=1000

% line spacing
\renewcommand{\baselinestretch}{1.20}

% heading style - bold and sans-serif
%% sectsty (2002) checks \underbar/\underline against their pre-2020 kernel
%% definitions and warns "Command \underline has changed". The check is
%% purely informational, so it is skipped while sectsty is loaded.
\let\upsgSavedCheckCommand\CheckCommand
\def\CheckCommand*#1[#2]#3{}
\RequirePackage{sectsty}
\let\CheckCommand\upsgSavedCheckCommand
\allsectionsfont{\sffamily}

% header and footer setup: outer edge in twoside (odd right, even left),
% right edge in oneside (fancyhdr warns about `E' positions without twoside)
\makeatletter
\if@twoside
  \def\upsgOuter{RO,LE}
\else
  \def\upsgOuter{R}
\fi
\makeatother
\fancyhf{}
\expandafter\fancyhead\expandafter[\upsgOuter]{\rightmark}
\expandafter\fancyfoot\expandafter[\upsgOuter]{\thepage}
\renewcommand{\footrulewidth}{.5pt}
\fancypagestyle{plain}{%
\fancyhf{} % clear all header and footer fields
\expandafter\fancyfoot\expandafter[\upsgOuter]{\thepage}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0.5pt}}

% tables of contents without page numbers on their own entries
\addtocontents{toc}{\protect\thispagestyle{empty}}
\addtocontents{lot}{\protect\thispagestyle{empty}}
\addtocontents{lof}{\protect\thispagestyle{empty}}

% These macros use a mildly ugly LaTeX trick to make chapter headings
% typeset more sensibly and not leave a huge gap above them. Ignore boldly.
\makeatletter
\def\@makechapterhead#1{
  {\parindent \z@ \raggedright \sffamily
   \Huge\bfseries \thechapter. #1
   \par\nobreak
   \vskip 20\p@
}}
\def\@makeschapterhead#1{
  {\parindent \z@ \raggedright \sffamily
   \Huge\bfseries #1
   \par\nobreak
   \vskip 20\p@
}}
\makeatother

% Somewhat looser word-hyphenation settings than the default (at least 2
% letters before/after a hyphen). babel resets \lefthyphenmin/\righthyphenmin
% to the language's own values at every language switch (incl. at
% \begin{document}; English uses 2/3), so set them through babel.
\ifdefined\babelhyphenmins
  \babelhyphenmins[\ifupsgCzech czech\else english\fi]{2}{2}
\else % babel older than 3.98
  \expandafter\def\csname\ifupsgCzech czech\else english\fi hyphenmins\endcsname{22}
\fi

% More aggressive hyphenation: LaTeX normally first tries to break a line
% WITHOUT hyphenation (\pretolerance) and only hyphenates if that fails.
% \pretolerance=-1 skips that first pass, so hyphenation is always
% considered. Lower hyphenation penalties and a higher tolerance further
% reduce the number of overfull lines; \emergencystretch is a safety net
% for cases that can't be broken at all (long \url, \texttt, etc.).
\pretolerance=-1
\tolerance=1500
\hyphenpenalty=50
\exhyphenpenalty=50
\emergencystretch=3em

% With the `markoverfull` class option, black "slugs" mark the end of
% overflowing lines, so they are easy to spot while writing. Off by default
% so they never end up in the submitted PDF.
\ifupsgMarkOverfull
  \overfullrule=1mm
\else
  \overfullrule=0pt
\fi

%%% Environment for typesetting code, or the input/output of computer
%%% programs, with syntax highlighting (via the listings package). Usage:
%%%   \begin{code}[Python] ... \end{code}   -- highlighted as Python
%%%   \begin{code} ... \end{code}           -- plain, no highlighting
%%% The language name is whatever `listings` recognizes (Python, Java, C,
%%% [LaTeX]TeX, bash, SQL, ...); see the listings package documentation
%%% for the full list.
\RequirePackage{listings}
\definecolor{codebackground}{gray}{0.97}
\definecolor{codekeyword}{RGB}{0,70,140}
\definecolor{codecomment}{RGB}{110,110,110}
\definecolor{codestring}{RGB}{140,20,20}
\lstset{
  basicstyle=\ttfamily\small\linespread{0.9}\selectfont,
  keywordstyle=\bfseries\color{codekeyword},
  commentstyle=\color{codecomment},
  stringstyle=\color{codestring},
  backgroundcolor=\color{codebackground},
  frame=single,
  framerule=0.4pt,
  rulecolor=\color{black!40},
  breaklines=true,
  breakatwhitespace=true,
  showstringspaces=false,
  columns=fullflexible,
  keepspaces=true,
  tabsize=4,
  numbers=none,
  % Accented characters, so Czech text/comments inside a listing render correctly.
  literate=%
    {á}{{\'a}}1 {č}{{\v c}}1 {ď}{{\v d}}1 {é}{{\'e}}1 {ě}{{\v e}}1
    {í}{{\'i}}1 {ň}{{\v n}}1 {ó}{{\'o}}1 {ř}{{\v r}}1 {š}{{\v s}}1
    {ť}{{\v t}}1 {ú}{{\'u}}1 {ů}{{\r u}}1 {ý}{{\'y}}1 {ž}{{\v z}}1
    {Á}{{\'A}}1 {Č}{{\v C}}1 {Ď}{{\v D}}1 {É}{{\'E}}1 {Ě}{{\v E}}1
    {Í}{{\'I}}1 {Ň}{{\v N}}1 {Ó}{{\'O}}1 {Ř}{{\v R}}1 {Š}{{\v S}}1
    {Ť}{{\v T}}1 {Ú}{{\'U}}1 {Ů}{{\r U}}1 {Ý}{{\'Y}}1 {Ž}{{\v Z}}1
}
\lstnewenvironment{code}[1][]{\ifstrempty{#1}{}{\lstset{language=#1}}}{}


%%%============================================================
%%% Localized strings
%%%============================================================
\ifupsgCzech
  \def\upsgStrInstitution{Univerzita Karlova}
  \def\upsgStrFaculty{Přírodovědecká fakulta}
  \def\upsgStrStudyProgramme{Studijní program}
  \def\upsgStrSupervisor{Vedoucí práce}
  \def\upsgStrCity{Praha}
  \def\upsgStrInCity{V Praze}
  \def\upsgStrDeclaration{Prohlášení}
  \def\upsgStrSignature{Podpis studenta}
  \def\upsgStrAcknowledgements{Poděkování}
  \def\upsgStrAppendices{Přílohy}
  \def\upsgStrBibliography{Seznam použité literatury}% babel's \bibname is just "Literatura"
  \def\upsgStrTypeBachelor{Bakalářská práce}
  \def\upsgStrTypeMaster{Diplomová práce}
  \def\upsgStrTypeRigorous{Rigorózní práce}
  \def\upsgStrTypeDissertation{Disertační práce}
  \def\upsgStrTypeLifelong{Závěrečná práce v programu celoživotního vzdělávání}
  \def\upsgDeclarationText#1{%
    Prohlašuji, že jsem závěrečnou práci \textit{#1} zpracoval/a samostatně a že jsem uvedl/a všechny použité informační zdroje a literaturu. Tato práce ani její podstatná část nebyla předložena k~získání jiného nebo stejného akademického titulu.%
  }
\else
  \def\upsgStrInstitution{Charles University}
  \def\upsgStrFaculty{Faculty of Science}
  \def\upsgStrStudyProgramme{Study Programme}
  \def\upsgStrSupervisor{Supervisor}
  \def\upsgStrCity{Prague}
  \def\upsgStrInCity{Prague}
  \def\upsgStrDeclaration{Declaration}
  \def\upsgStrSignature{Student's signature}
  \def\upsgStrAcknowledgements{Acknowledgements}
  \def\upsgStrAppendices{Appendices}
  \def\upsgStrBibliography{\bibname}% "Bibliography"
  \def\upsgStrTypeBachelor{Bachelor's Thesis}
  \def\upsgStrTypeMaster{Master's Thesis}
  \def\upsgStrTypeRigorous{Rigorous Thesis}
  \def\upsgStrTypeDissertation{Dissertation}
  \def\upsgStrTypeLifelong{Final Thesis in the Lifelong Learning Programme}
  \def\upsgDeclarationText#1{%
    I hereby declare that I have compiled this thesis, \textit{#1}, independently and that I have listed all the information sources and literature used. This thesis, or a substantial part of it, has not been submitted to obtain another or the same academic degree.%
  }
\fi


%%%============================================================
%%% Metadata-setting commands, called from the main .tex file
%%%============================================================
%% Every field starts empty, so omitting a setter never causes an
%% "Undefined control sequence" error. Missing mandatory fields produce a
%% class warning at \begin{document}; empty acknowledgements skip that page.
\def\upsgTitle{}\def\upsgTitleCZ{}\def\upsgAuthor{}\def\upsgSupervisor{}
\def\upsgStudyProgramme{}\def\upsgYear{}\def\upsgAcknowledgements{}
\def\upsgAbstract{}\def\upsgAbstractCZ{}\def\upsgKeywords{}\def\upsgKeywordsCZ{}
\newcommand{\ThesisTitle}[1]{\def\upsgTitle{#1}}
\newcommand{\ThesisTitleCZ}[1]{\def\upsgTitleCZ{#1}}
\newcommand{\ThesisAuthor}[1]{\def\upsgAuthor{#1}}
\newcommand{\Supervisor}[1]{\def\upsgSupervisor{#1}}
\newcommand{\StudyProgramme}[1]{\def\upsgStudyProgramme{#1}}
\newcommand{\YearSubmitted}[1]{\def\upsgYear{#1}}
\newcommand{\Acknowledgements}[1]{\def\upsgAcknowledgements{#1}}
\newcommand{\Abstract}[1]{\def\upsgAbstract{#1}}
\newcommand{\AbstractCZ}[1]{\def\upsgAbstractCZ{#1}}
\newcommand{\Keywords}[1]{\def\upsgKeywords{#1}}
\newcommand{\KeywordsCZ}[1]{\def\upsgKeywordsCZ{#1}}

\newcommand{\ThesisType}[1]{%
  \ifstrequal{#1}{bachelor}{\def\upsgType{\upsgStrTypeBachelor}}{%
  \ifstrequal{#1}{master}{\def\upsgType{\upsgStrTypeMaster}}{%
  \ifstrequal{#1}{rigorous}{\def\upsgType{\upsgStrTypeRigorous}}{%
  \ifstrequal{#1}{dissertation}{\def\upsgType{\upsgStrTypeDissertation}}{%
  \ifstrequal{#1}{lifelong}{\def\upsgType{\upsgStrTypeLifelong}}{%
  \ClassError{upsgthesis}{Unknown \string\ThesisType\space '#1'}{Use one of: bachelor, master, rigorous, dissertation, lifelong.}%
  }}}}}%
}
\ThesisType{bachelor}% default

\AtBeginDocument{%
  \def\upsgCheckField#1#2{%
    \ifdefempty{#1}{\ClassWarningNoLine{upsgthesis}{Mandatory field
      \string#2 is not set (or empty)}}{}}%
  \upsgCheckField\upsgTitle\ThesisTitle
  \upsgCheckField\upsgTitleCZ\ThesisTitleCZ
  \upsgCheckField\upsgAuthor\ThesisAuthor
  \upsgCheckField\upsgSupervisor\Supervisor
  \upsgCheckField\upsgStudyProgramme\StudyProgramme
  \upsgCheckField\upsgYear\YearSubmitted
  \upsgCheckField\upsgAbstract\Abstract
  \upsgCheckField\upsgAbstractCZ\AbstractCZ
  \upsgCheckField\upsgKeywords\Keywords
  \upsgCheckField\upsgKeywordsCZ\KeywordsCZ
}


%%%============================================================
%%% Structural commands, called from the main .tex file
%%%============================================================

%% Title page and mandatory information pages (replaces \include{required/titlepage}).
\newcommand{\thesisfrontmatter}{%
\pagestyle{empty}
\hypersetup{pageanchor=false}

\begin{titlepage}
\centering
{\large \textbf{\upsgStrInstitution} \\
\textbf{\upsgStrFaculty}} \\[10mm]

\upsgStrStudyProgramme: \upsgStudyProgramme \\[2cm]

\includegraphics[height=7cm]{assets/logo_color}\par
\vspace{2cm}

{\large \textbf{\upsgAuthor}} \\[1cm]

\ifupsgCzech \upsgTitleCZ \\ \upsgTitle \\[1cm]
\else \upsgTitle \\ \upsgTitleCZ \\[1cm]
\fi

\upsgType \\[1cm]

\upsgStrSupervisor: \textbf{\upsgSupervisor}\\
\null\vfill

\upsgStrCity, \upsgYear
\end{titlepage}

\hypersetup{pageanchor=true}
\pagestyle{empty}
\openright
\vspace*{\fill}
\section*{\upsgStrDeclaration}
\noindent
\ifupsgCzech \upsgDeclarationText{\upsgTitleCZ}\else \upsgDeclarationText{\upsgTitle}\fi

\vspace{2cm}
\noindent
\upsgStrInCity, \upsgDate \hfill
\hfill%
\begin{minipage}[t]{.5\textwidth}%
\begin{center}
\dotfill\\
\upsgStrSignature
\end{center}
\end{minipage}
\vspace{1cm}

\ifdefempty{\upsgAcknowledgements}{}{%
\openright
\vspace*{\fill}
\section*{\upsgStrAcknowledgements}
\noindent
\upsgAcknowledgements
\vspace*{\fill}
}

\openright
\ifupsgCzech
  \section*{Abstrakt}
  \noindent
  \upsgAbstractCZ
  \subsection*{Klíčová slova}
  \noindent
  \upsgKeywordsCZ

  \bigskip\bigskip\bigskip
  \section*{Abstract}
  \noindent
  \upsgAbstract
  \subsection*{Keywords}
  \noindent
  \upsgKeywords
\else
  \section*{Abstract}
  \noindent
  \upsgAbstract
  \subsection*{Keywords}
  \noindent
  \upsgKeywords

  \bigskip\bigskip\bigskip
  \section*{Abstrakt}
  \noindent
  \upsgAbstractCZ
  \subsection*{Klíčová slova}
  \noindent
  \upsgKeywordsCZ
\fi

\openright
\setcounter{tocdepth}{2}
\phantomsection
\addcontentsline{toc}{chapter}{\contentsname}
\tableofcontents

\openright
\phantomsection
\addcontentsline{toc}{chapter}{\listfigurename}
\listoffigures

\clearpage
\phantomsection
\addcontentsline{toc}{chapter}{\listtablename}
\listoftables
}

%% Bibliography (replaces \include{required/bibliography}).
\newcommand{\thesisbibliography}{%
\printbibliography[title={\upsgStrBibliography},heading={bibintoc}]%
}

%% Appendices part heading + \appendix (replaces the \part*{...}\appendix boilerplate).
%% \part* is unnumbered and would not appear in the ToC/bookmarks; add the
%% entry by hand on the (already cleared) part page so it links correctly.
\newcommand{\thesisappendices}{%
\openright
\phantomsection
\addcontentsline{toc}{part}{\upsgStrAppendices}%
\part*{\upsgStrAppendices}%
\appendix
}
