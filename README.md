# upsg-sablona

A LaTeX thesis template for Charles University, Faculty of Science (Přírodovědecká fakulta UK), packaged as a document class (`upsgthesis.cls`) with the thesis language selected as a class option. Available in **[English](#english)** and **[Czech / Česky](#česky)**.

---

## How to

`upsgthesis.cls` is a self-contained LaTeX document class holding all formatting logic — page margins, title page, declaration, acknowledgements, bilingual abstract, table of contents, bibliography, and package configuration — for a bachelor's/master's thesis at Charles University, Faculty of Science. The thesis language is chosen via a class option:

```latex
\documentclass[english,12pt,a4paper]{upsgthesis}   % English-primary thesis
\documentclass[czech,12pt,a4paper]{upsgthesis}      % Czech-primary thesis
```

Two ready-to-use example main files demonstrate it: `thesis-en.tex` and `thesis-cs.tex`.

Per Charles University's formal requirements, **both** a Czech and an English title/abstract/keywords are mandatory regardless of which language the thesis body is written in — the class option only decides which one is primary (printed first, and which language drives babel, citation sorting, and all front-matter labels).

### Requirements

- A TeX distribution with `pdflatex`, `biber`, and the packages this class loads (`geometry`, `tocloft`, `pdfx`, `hyperref`, `babel` with `czech`+`english`, `biblatex` + `biblatex-apa`, `fancyhdr`, `booktabs`, `dcolumn`, and a few others — all standard in a full TeX Live/MiKTeX install).
- `czech-apa.lbx` and `english-apa.lbx` (bundled in this repo) must stay in the same directory as the main `.tex` file you compile — `biblatex-apa` ships no Czech localization, so this template carries its own.

### Quick start

1. Copy whichever example matches your thesis language — `thesis-en.tex` (+ `chapters-en/`, `appendices-en/`) or `thesis-cs.tex` (+ `chapters-cs/`, `appendices-cs/`) — and rename them for your thesis (e.g. `thesis-en.tex` → `mythesis.tex`).
2. Edit the metadata macros at the top of your main file: `\ThesisTitle`, `\ThesisTitleCZ`, `\ThesisAuthor`, `\Supervisor`, `\StudyProgramme`, `\YearSubmitted`, `\Acknowledgements`, `\Abstract`/`\AbstractCZ`, `\Keywords`/`\KeywordsCZ`, and `\ThesisType{bachelor|master|rigorous|dissertation|lifelong}`.
3. Write your chapters as separate `.tex` files (see `chapters-en/`/`chapters-cs/` for the pattern) and `\include` them between `\thesisfrontmatter` and `\thesisbibliography`.
4. Add references to `bibliography.bib` and cite them with `\cite{key}`. To use a different filename, call `\Bibliography{myrefs.bib}` in the main file before `\begin{document}`.
5. Build (see below).

### Build

There is no Makefile or `latexmk` config — run the chain manually, using your main file's jobname (`thesis-en`/`thesis-cs` for the examples):

```bash
pdflatex thesis-en.tex
biber thesis-en
pdflatex thesis-en.tex
pdflatex thesis-en.tex   # second pass to resolve cross-references/TOC
```

Output: `thesis-en.pdf`. Everything else generated during the build (`.aux`, `.bbl`, `.log`, etc., plus `pdfa.xmpi`) is a build artifact — safe to delete, and already excluded from version control via `.gitignore`.

### Structure

| Path | Purpose |
|---|---|
| `upsgthesis.cls` | The class — all structure/margins/packages/language logic. Edit here for document-wide formatting changes. |
| `thesis-en.tex` / `thesis-cs.tex` | Example main files. Copy and rename to start a real thesis. |
| `chapters-en/` / `chapters-cs/` | Thesis chapters, one file per chapter, `\include`d from the main file. |
| `appendices-en/` / `appendices-cs/` | Appendices, `\include`d after `\thesisappendices`. Every appendix must be referenced at least once from the main text. |
| `bibliography.bib` | Default bibliography database (BibTeX/biblatex format); override with `\Bibliography{filename.bib}`. |
| `figures/` | Shared image assets, including the faculty logos. |
| `czech-apa.lbx` / `english-apa.lbx` | APA citation-style localization files the class depends on. |

### Customization

- **Sides**: add `twoside,openright` to the `\documentclass[...]` options for double-sided printing; margins and page-break behavior (`\openright`) adapt automatically.
- **Thesis type**: `\ThesisType{bachelor}` (or `master`/`rigorous`/`dissertation`/`lifelong`) — always produces the correctly localized string for the active language.
- **Citation style**: the class defaults to `style=apa`; see `chapters-en/chap03.tex`/`chapters-cs/kap03.tex` for how to switch styles or use plain `thebibliography` instead of a database.
- **Typography**: see `chapters-en/chap01.tex`/`chapters-cs/kap01.tex` for the non-breaking-space, quoting, and dash conventions this template follows.

---

### Jak na to

`upsgthesis.cls` je samostatná třída LaTeXu obsahující veškerou formátovací logiku — okraje stránky, titulní stranu, prohlášení, poděkování, dvojjazyčný abstrakt, obsah, bibliografii i nastavení balíčků — pro bakalářskou/diplomovou práci na Přírodovědecké fakultě Univerzity Karlovy. Jazyk práce se volí přes volbu třídy:

```latex
\documentclass[english,12pt,a4paper]{upsgthesis}   % práce primárně v angličtině
\documentclass[czech,12pt,a4paper]{upsgthesis}      % práce primárně v češtině
```

Použití demonstrují dva hotové hlavní soubory: `thesis-en.tex` a `thesis-cs.tex`.

Podle formálních požadavků Univerzity Karlovy jsou **vždy** povinné jak český, tak anglický název/abstrakt/klíčová slova, bez ohledu na to, v jakém jazyce je psán vlastní text práce — volba třídy pouze určuje, který z nich je primární (tiskne se první a jeho jazyk řídí babel, řazení citací a popisky na titulní straně).

### Požadavky

- Distribuce TeXu s `pdflatex`, `biber` a balíčky, které tato třída načítá (`geometry`, `tocloft`, `pdfx`, `hyperref`, `babel` s `czech`+`english`, `biblatex` + `biblatex-apa`, `fancyhdr`, `booktabs`, `dcolumn` a několik dalších — vše běžná součást plné instalace TeX Live/MiKTeX).
- Soubory `czech-apa.lbx` a `english-apa.lbx` (součástí tohoto repozitáře) musí zůstat ve stejném adresáři jako hlavní `.tex` soubor, který kompilujete — balíček `biblatex-apa` česká lokalizace neobsahuje, tato šablona si ji nese vlastní.

### Rychlý start

1. Zkopírujte příklad odpovídající jazyku vaší práce — `thesis-en.tex` (+ `chapters-en/`, `appendices-en/`) nebo `thesis-cs.tex` (+ `chapters-cs/`, `appendices-cs/`) — a přejmenujte podle své práce (např. `thesis-cs.tex` → `mojeprace.tex`).
2. Upravte makra s údaji o práci na začátku hlavního souboru: `\ThesisTitleCZ`, `\ThesisTitle`, `\ThesisAuthor`, `\Supervisor`, `\StudyProgramme`, `\YearSubmitted`, `\Acknowledgements`, `\AbstractCZ`/`\Abstract`, `\KeywordsCZ`/`\Keywords` a `\ThesisType{bachelor|master|rigorous|dissertation|lifelong}`.
3. Kapitoly pište jako samostatné `.tex` soubory (viz vzor v `chapters-cs/`/`chapters-en/`) a vkládejte je příkazem `\include` mezi `\thesisfrontmatter` a `\thesisbibliography`.
4. Do `bibliography.bib` doplňte reference a citujte je pomocí `\cite{klíč}`. Pro jiný název souboru zavolejte v hlavním souboru před `\begin{document}` příkaz `\Bibliography{muj_seznam.bib}`.
5. Sestavte dokument (viz níže).

### Sestavení (build)

Neexistuje Makefile ani konfigurace `latexmk` — sekvenci spouštějte ručně, s jobname podle vašeho hlavního souboru (`thesis-en`/`thesis-cs` u příkladů):

```bash
pdflatex thesis-cs.tex
biber thesis-cs
pdflatex thesis-cs.tex
pdflatex thesis-cs.tex   # druhý průchod kvůli křížovým odkazům a obsahu
```

Výstup: `thesis-cs.pdf`. Vše ostatní vzniklé při sestavení (`.aux`, `.bbl`, `.log` atd. a `pdfa.xmpi`) jsou pomocné soubory buildu — lze je bez obav smazat, a jsou už vyloučeny z verzování přes `.gitignore`.

### Struktura

| Cesta | Účel |
|---|---|
| `upsgthesis.cls` | Třída — veškerá struktura/okraje/balíčky/jazyková logika. Zde upravujte formátování platné pro celý dokument. |
| `thesis-en.tex` / `thesis-cs.tex` | Ukázkové hlavní soubory. Zkopírujte a přejmenujte pro skutečnou práci. |
| `chapters-en/` / `chapters-cs/` | Kapitoly práce, jeden soubor na kapitolu, vkládané příkazem `\include` z hlavního souboru. |
| `appendices-en/` / `appendices-cs/` | Přílohy, vkládané po `\thesisappendices`. Každá příloha musí být alespoň jednou odkazována z vlastního textu. |
| `bibliography.bib` | Výchozí databáze literatury (formát BibTeX/biblatex); jiný soubor lze nastavit příkazem `\Bibliography{název.bib}`. |
| `figures/` | Sdílené obrázky, včetně loga fakulty. |
| `czech-apa.lbx` / `english-apa.lbx` | Lokalizační soubory citačního stylu APA, na kterých třída závisí. |

### Přizpůsobení

- **Jednostranný/oboustranný tisk**: pro oboustranný tisk přidejte do voleb `\documentclass[...]` `twoside,openright`; okraje i chování zalomení stránky (`\openright`) se přizpůsobí automaticky.
- **Typ práce**: `\ThesisType{bachelor}` (nebo `master`/`rigorous`/`dissertation`/`lifelong`) — vždy vygeneruje správně lokalizovaný text podle aktivního jazyka.
- **Citační styl**: výchozí je `style=apa`; viz `chapters-cs/kap03.tex`/`chapters-en/chap03.tex`, jak přepnout styl nebo použít prostředí `thebibliography` místo databáze.
- **Typografie**: viz `chapters-cs/kap01.tex`/`chapters-en/chap01.tex` pro konvence nedělitelných mezer, uvozovek a pomlček, které tato šablona dodržuje.
