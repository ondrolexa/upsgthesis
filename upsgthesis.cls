%%% upsgthesis.cls
%%% Charles University, Faculty of Science -- bachelor's/master's thesis class.
%%%
%%% Single source of truth for structure, margins, title page, and packages.
%%% Thesis language is selected as a class option:
%%%   \documentclass[english]{upsgthesis}
%%%   \documentclass[czech]{upsgthesis}
%%% All other options (12pt, a4paper, twoside, openright, ...) are passed
%%% through to the underlying `report` class unchanged.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{upsgthesis}[2026/07/22 v1.0 Charles University PrF thesis class]

\newif\ifupsgCzech
\DeclareOption{english}{\upsgCzechfalse}
\DeclareOption{czech}{\upsgCzechtrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
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
\RequirePackage[a-2u]{pdfx}     % the resulting PDF will conform to the PDF/A-2u standard
\hypersetup{hidelinks}
\hypersetup{pdfa}
\hypersetup{unicode}

%% Language: Czech or English typesetting, Latin Modern fonts, proper font encoding.
\ifupsgCzech
  \RequirePackage[czech]{babel}
\else
  \RequirePackage[english]{babel}
\fi
\RequirePackage{lmodern}
\RequirePackage[T1]{fontenc}
\RequirePackage{zi4}            % Inconsolata: a more condensed, modern monospace font for code
\RequirePackage{textcomp}
\RequirePackage[utf8]{inputenc}
\RequirePackage{csquotes}
\RequirePackage{datetime}
\ifupsgCzech
  \newdateformat{thesisdate}{\THEDAY. \THEMONTH. \THEYEAR}
\else
  \newdateformat{thesisdate}{\THEDAY~\monthname[\THEMONTH]~\THEYEAR}
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
\DeclareSIUnit\annum{a}
\DeclareSIUnit\kbar{kbar}
\DeclareSIUnit\wtpercent{wt\%}
\DeclareSIUnit\ppm{ppm}
\ifupsgCzech
  \sisetup{output-decimal-marker = {,}}
\else
  \sisetup{output-decimal-marker = {.}}
\fi
\makeatletter
\@ifpackageloaded{xcolor}{
   \@ifpackagewith{xcolor}{usenames}{}{\PassOptionsToPackage{usenames}{xcolor}}
  }{\RequirePackage[usenames]{xcolor}} % colour typesetting
\makeatother
\RequirePackage{multicol}       % working with multiple columns on a page
\RequirePackage[font={small,it}]{caption}
\RequirePackage{enumitem}
\setlist[itemize]{noitemsep, topsep=0pt, partopsep=0pt}
\setlist[enumerate]{noitemsep, topsep=0pt, partopsep=0pt}
\setlist[description]{noitemsep, topsep=0pt, partopsep=0pt}

% paragraph styling
\parindent=0pt
\parskip=11pt

% forbid widows and orphans - single-line paragraph starts/ends across a page break
\clubpenalty=1000
\widowpenalty=1000
\displaywidowpenalty=1000

% line spacing
\renewcommand{\baselinestretch}{1.20}

% heading style - bold and sans-serif
\RequirePackage{sectsty}
\allsectionsfont{\sffamily}

% header and footer setup
\fancyhf{}
\fancyhead[RO,LE]{\rightmark}
\fancyfoot[RO,LE]{\thepage}
\renewcommand{\footrulewidth}{.5pt}
\fancypagestyle{plain}{%
\fancyhf{} % clear all header and footer fields
\fancyfoot[RO,LE]{\thepage}
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

% Somewhat looser word-hyphenation settings than the default.
\lefthyphenmin=2
\righthyphenmin=2

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

% Turns on black "slugs" at the end of overflowing lines, so we notice
% them more easily.
\overfullrule=1mm

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

\begin{figure}[h!]
\begin{center} \includegraphics[height=7cm]{assets/logo_color}
\end{center}
\end{figure}
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

\openright

\hypersetup{pageanchor=true}
\pagestyle{empty}
\openright
\vspace*{\fill}
\section*{\upsgStrDeclaration}
\noindent
\ifupsgCzech \upsgDeclarationText{\upsgTitleCZ}\else \upsgDeclarationText{\upsgTitle}\fi

\vspace{2cm}
\noindent
\upsgStrInCity, \thesisdate\today \hfill
\hfill%
\begin{minipage}[t]{.5\textwidth}%
\begin{center}
\dotfill\\
\upsgStrSignature
\end{center}
\end{minipage}
\vspace{1cm}

\openright
\vspace*{\fill}
\section*{\upsgStrAcknowledgements}
\noindent
\upsgAcknowledgements
\vspace*{\fill}

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
\ifupsgCzech
  \printbibliography[title={Seznam použité literatury},heading={bibintoc}]%
\else
  \printbibliography[heading={bibintoc}]%
\fi
}

%% Appendices part heading + \appendix (replaces the \part*{...}\appendix boilerplate).
\newcommand{\thesisappendices}{%
\part*{\upsgStrAppendices}%
\appendix
}
