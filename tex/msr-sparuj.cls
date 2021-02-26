\ProvidesClass{msr-sparuj}
\LoadClass{article}
\pdfoutput=1 

\RequirePackage{msr-ocg-p}
\RequirePackage{xkeyval}
\newif\ifMSRfield\MSRfieldtrue\DeclareOptionX{nofield}{\MSRfieldfalse}  % R.M. 17.7.

\def\msr@scalepaper{1} 
\DeclareOptionX{scalepaper}{\xdef\msr@scalepaper{#1}}

\DeclareOptionX{random}{\def\msr@randomi{#1}}

\newif\if@msr@preview \@msr@previewfalse
\DeclareOptionX{proofing}{\@msr@previewtrue}

\newif\if@msr@for@png\@msr@for@pngfalse
\DeclareOptionX{preview}{\@msr@for@pngtrue\def\MsrObrazekKoncovka{png}}

\newif\if@dps@fixed \@dps@fixedfalse
\DeclareOptionX{nepermutuj}{\@dps@fixedtrue}

\newif\if@msr@rand@minipage \@msr@rand@minipagefalse
\DeclareOptionX{minipage}{\@msr@rand@minipagetrue}

\DeclareOptionX{mrizka}{\AtEndOfClass{\RequirePackage[bl]{pagegrid}}}

\def\msr@bublina{}
\DeclareOptionX{bublina}{\def\msr@bublina{#1}}

\def\MsrBublinaZpozdenaA{}
\def\MsrBublinaZpozdenaB{}
\DeclareOptionX{bublinakonec}{%
  \def\MsrBublinaZpozdenaA{var ttp=this.getField("jmeno"); if (ttp!=null) {ttp.hidden=true;}}
  \def\MsrBublinaZpozdenaB{var ttp=this.getField("jmeno"); if (ttp!=null) {ttp.hidden=false; ttp.setFocus();}}
}
  
\newif\if@msr@film \@msr@filmfalse
\DeclareOptionX{sesit}{\@msr@filmtrue \PassOptionsToPackage{neprehazovatotazky}{MSRdps_rand}}

\def\MsrError#1#2#3{\PackageWarning{#1}{#2}}
\DeclareOptionX{final}{\let\MsrError\PackageError}

\ProcessOptionsX

\newif\ifeqforpaper
\eqforpaperfalse
\usepackage{xcolor}
\usepackage[pdftex]{eforms}

\usepackage{graphicx}
\usepackage{pgf}

\input msr-ocgs.tex
\if@msr@preview\else
\input msr-kontrolapluginu.tex
\fi

\newcommand\firstMessageField[1][0.6\linewidth]{\placeMessageField[1]{#1}{45pt}}
\ifMSRfield\AtEndDocument{\firstMessageField\null\clearpage}\fi
\usepackage{MSRdps}


\ifx\msr@randomi\undefined\else \expandafter\randomi\msr@randomi
\message{^^J MsR: randomi je \the\randomi}\nextrandom\nextrandom\nextrandom
\fi

\rowsep{2ex}

\pagestyle{empty}
\parindent0pt
\parskip6pt

\newwrite\MSRvarianty
\immediate\openout\MSRvarianty=\jobname.varianty.msr

\newcount\pocetOtazekHry
\newcount\pocetOdpovediHry

\long\def\zapsat#1{\toks0={#1}\immediate\write\MSRvarianty{\the\toks0}}

\long\def\@@@pismeno#1#2#3{%
\global\advance\pocetOtazekHry 1
\global\advance\pocetOdpovediHry 1
\zapsat{\begin{cQ}{#1}#2\Konec}%
\zapsat{\end{cQ}}%
\zapsat{\begin{cA}{#1}#3\Konec}%
\zapsat{\end{cA}}%
\expandafter\zapsat\expandafter{\expandafter\gdef\expandafter\MSRpocetotazek\expandafter{\the\pocetOtazekHry}}%
\expandafter\zapsat\expandafter{\expandafter\gdef\expandafter\MSRpocetodpovedi\expandafter{\the\pocetOdpovediHry}}%
}

\if@dps@fixed
\let\pismeno\@@@pismeno
\else
\long\def\@@@otazka#1#2{\@@@pismeno{}{#1}{#2}}
\long\def\Otazka#1\Konec#2\Konec{\@@@pismeno{}{#1}{#2}}
\long\def\otazka{\@ifstar\@@otazka\@@@otazka}
\long\def\@@otazka#1\par#2\par{\@@@pismeno{}{#1}{#2}}
\fi

\newcount\MSRfakecount
\def\fake#1{
\global\advance\pocetOdpovediHry 1
\global\advance\MSRfakecount by 1
\expandafter\zapsat\expandafter{\expandafter\begin\expandafter{\expandafter c\expandafter A\expandafter}\expandafter{\the\MSRfakecount}#1\Konec}
\zapsat{\end{cA}}
\expandafter\zapsat\expandafter{\expandafter\gdef\expandafter\MSRpocetodpovedi\expandafter{\the\pocetOdpovediHry}}%
}

%%%%%%%%%%%%% this shows letters for answers
\renewcommand{\dpsA}[2][]{\color{blue!50!black}\item\relax\color{black}\ifeqforpaper\else
    \edef\checkboxTmp{\noexpand\checkBox[\the\AnsAppearancetoks
    \noexpand\A{\noexpand\JS{processChoice("#2","\MSRaaa")}}]%
    {ckbxA.#2}{14bp}{11bp}{Yes}}\makebox[0pt][r]{\checkboxTmp\,}\fi
    \def\argi{#1}%
        % \ifshowletters
        %     \ifx\argi\@empty
        %         \let\getLetterNext\relax
        %         \let\ds@foundLetter=0\def\ds@currFN{#2}%
        %         \def\getLetterNext{\ds@typesetPuzzleLetter}%
        %         \expandafter\getLetterNext
        %     \else
        %         \makebox[0pt][r]{\Hy@pdfstringfalse#1\enspace\kern4bp}%
        %     \fi
        % \fi
    \ \ignorespaces
}

\if@msr@preview
\PuzzleAppearance{\textSize{0}\BC{1 0 0}\BG{}}
\else
\PuzzleAppearance{\textSize{0}\BC{1 0 0}\textColor{0 0.7 0 rg}}
\fi

\input msr-vzhled.tex

% Titulni strana
\AtBeginDocument{
 \immediate\closeout\MSRvarianty
 \begin{Composing}
 \input \jobname.varianty.msr
 \end{Composing}
 \maketitle
 \thispagestyle{empty}
 \newpage\newgeometry{margin=12pt, top=12pt, bottom=12pt}}

% test, jestli nedoslo ke strankovemu zlomu za tajenkou. citac \MsrTajenkaStranka je definovan v MSRdps.sty
% pokud neni pouzita tajenka, testuje se jeste stranka s otazkami
\newcount \MsrPosledniStranka
% nasledujici trik viz http://www.tug.org/tugboat/tb19-1/tb58works.pdf
\AtEndDocument{\clearpage\addtocounter{page}{-1}\immediate\write\@auxout{\global\MsrPosledniStranka=\thepage}\addtocounter{page}{1}%
\ifnum \the\MsrTajenkaStranka > 0
   \advance\MsrTajenkaStranka  by 1\relax
   \ifnum\the\MsrPosledniStranka=\the\MsrTajenkaStranka \else\MsrError{msr-sparuj}{Tajenka neni na predposledni strane, neco je spatne ...}{}\fi
\fi
\ifnum \the\MsrOtazkyStranka > 0
   \advance\MsrOtazkyStranka  by 1\relax
   \ifnum\the\MsrPosledniStranka=\the\MsrOtazkyStranka \else\MsrError{msr-sparuj}{Otazky nejsou na predposledni strane, neco je spatne ...}{}\fi
\fi
}

\newcount\MsrObrazekStranka

\def\insertPuzzleHookMSR{\pracuj}

\if@msr@preview
\AtBeginShipout{\AtBeginShipoutUpperLeftForeground{\lower \pdfpageheight \hbox to 0 pt{\raise 3pt \hbox{\colorbox{yellow}{\MSRaaa}}\hss}}}
\fi

\if@msr@for@png\def\msr@hodnoceni{}\fi

%%% pdfcomment nebudeme pouzivat (2.3.2013)
% \usepackage{pdfcomment}
% \def\instrukce#1{\leavevmode\pdfcomment[icon=Help,opacity=0.5]{#1}}
\def\instrukce#1{}
% \hypersetup{unicode=true} 

\def\@maketitle{%
  \newpage
  \null
  \dimen0=12em
  \vskip \msr@scalepaper\dimen0%
  \begin{center}%
  \let \footnote \thanks
    {\Large \textbf{\@title}\par}%
    Párovací hra -- \csname msr@@obtiznost@\msr@obtiznost\endcsname
  \end{center}%
  \hypertarget{home}{}
  \par
  \begin{center}
    \begin{minipage}{0.85\linewidth}
      Cílem hry je spárovat otázky a odpovìdi s co
      nejmenším poètem chybných pokusù. 
      \ifnum \MsrTajenkaStranka = 0 \else Po správném vyøešení každého
      problému se zobrazí èást tajenky. \fi
      \ifnum \MsrObrazekStranka = 0 \else Bìhem hry se pøi správném spárování otázek a odpovìdí postupnì odkrývá 
      zajímavý obrázek. \fi
      Další informace k ovládání hry
      naleznete na
      \href{http://msr.vsb.cz/napoveda/parovaci-hry}{\color{odkaz}http://msr.vsb.cz/napoveda/parovaci-hry}.
    \end{minipage}

    \vfill
    \expandafter\ifx\csname \msr@autor\endcsname\relax
    \MsrError{msr}{Jmeno "\msr@autor" neni v databazi autoru, bud se jedna o preklep nebo je nutno doplnit databazi autoru.}{}
    Hra byla vytvoøena v rámci projektu \href{http://msr.vsb.cz/}{\color{odkaz}Matematika s radostí}.
    \else
    Hra byla vytvoøena v rámci projektu \href{http://msr.vsb.cz/}{\color{odkaz}Matematika s radostí} dle návrhu \csname \msr@autor\endcsname.
    \fi

    \bigskip

    \includegraphics[width=0.3\paperwidth]{OPVK_cb.pdf}
    \vskip -2\bigskipamount
    \def\msr@@jedna{1}\ifx\msr@scalepaper\msr@@jedna\else \vskip \medskipamount\fi
    \null
  \end{center}
  \newpage
}


\def\hodnoceni@#1#2#3{
\ifnum\thepage=#3\AtBeginShipoutUpperLeftForeground{\lower \pdfpageheight \hbox to 0 pt{%
\hbox to \hsize{\hss  \raise 3pt \hbox{\begin{ocg}{hotovo}{hotovo}0\large \Acrobatmenu{#1}{#2}\end{ocg}}\hskip 1.2cm}\hss}}\fi
}

\AtBeginShipout{%
\hodnoceni@{NextPage}{\includegraphics[width=2.3cm]{msr_sparuj_hodnoceni.pdf}}{\MsrOtazkyStranka}%
\hodnoceni@{PrevPage}{\includegraphics[width=2.3cm]{msr_sparuj_hraci_pole.pdf}}{\MsrPosledniStranka}%
}


\if@dps@fixed\else 
\RequirePackage{MSRdps_rand}
\if@msr@rand@minipage
  \def\OtazkaBox#1{\begin{minipage}{1.0\linewidth}%
      #1
    \end{minipage}}
  \let\OdpovedBox\OtazkaBox
\fi
\fi


\ifx\msr@bublina\empty\else

\newbox\fancytooltips@img
\newbox\fancytooltips@imgB
\RequirePackage{pifont}
\def\bublina#1{%
     \global\setbox\fancytooltips@img=\hbox{\includegraphics[]{\msr@bublina}}%
     \global\setbox\fancytooltips@imgB=\hbox{\includegraphics[]{\msr@bublina}\lower 10pt \hbox{\raise \ht\fancytooltips@img\hbox to 0 pt{\hss\color{red}\LARGE\ding{56}}}}%
     \dimen0=\ht\fancytooltips@img
     \advance\dimen0 by \dp\fancytooltips@img
     \global\ht\fancytooltips@img = \dimen0
     \immediate\pdfxform\fancytooltips@imgB
     \xdef\normalappearance{\the\pdflastxform\space 0 R}%
     \gdef\ZIVOTOPIS@{\pushButton[\W{0}\BG{}\S{S}\BC{}\H{N}\F{\FHidden}%
         \mkIns{
           /TP 1 /IF<</S/P/SW/B/FB true/A [0.5 0.7]>>
           /I \normalappearance%
         }\A{\JS{this.getField("zivotopis").hidden=true;this.getField("jmeno").hidden=false;}}
         ]{zivotopis}{\the\pdfpagewidth}{\the\pdfpageheight}}%
     %\AddToShipoutPictureFG*{\AtPageUpperLeft{\begin{ocg}{kryt}{kryt}0\vbox to 0pt{\relax\transparent{0.5}\hrule width \paperwidth height 0 pt depth \paperheight\vss}\end{ocg}}}%
     \AddToShipoutPictureFG{\AtPageUpperLeft{\vbox to 0pt{\vbox to \paperheight{\vss\hbox to \paperwidth{\hss\hbox{\ZIVOTOPIS@}\hss}\vss\vss}\vss}}}%
\setbox0=\hbox{{\msr@udensdot{#1}\hbox to 0 pt{\smash{\raisebox{0.4em}{\includegraphics[width=0.7em]{fancytipmark3.pdf}}}\hss}}}%
\leavevmode\hbox{\hbox to 0 pt{\copy0\hss}%
\pushButton[\A{\JS{this.getField("zivotopis").hidden=false;this.getField("jmeno").hidden=true}}\BG{}\BC{}\S{}\H{N}]{jmeno}{\wd0}{\ht0}}%
}

\if@msr@for@png
\long\def\bublina#1{\leavevmode\hbox{\msr@udensdot{#1}\hbox to 0 pt{\smash{\raisebox{0.4em}{\includegraphics[width=0.7em]{fancytipmark3.pdf}}}\hss}}\expandafter\AtEndDocument\expandafter{\includegraphics[width=0.9\linewidth]{\msr@bublina}}}
\fi

% dotted line from http://tex.stackexchange.com/questions/27258/how-do-i-write-underline-text-but-with-a-dotted-line
\newcommand{\msr@udensdot}[1]{%
    \tikz[baseline=(todotted.base)]{\color{blue}
        \node[inner sep=0pt,outer sep=0pt] (todotted) {\smash{#1}};
        \draw[dotted] ($(todotted.south west)+(5pt,-2pt)$) -- ($(todotted.south east)+(-5pt,-2pt)$);
    }%
}%

%\RequirePackage{transparent}

\fi

\if@msr@for@png
\def\VrstvaHotovo#1{\begin{ocg}{hotovo}{hotovo}{1}#1\end{ocg}}
\def\VrstvaTajenka#1{\begin{ocg}{tajenka}{tajenka}{1}#1\end{ocg}}
\else
\def\VrstvaHotovo#1{\begin{ocg}{hotovo}{hotovo}{0}#1\end{ocg}}
\def\VrstvaTajenka#1{\begin{ocg}{tajenka}{tajenka}{0}#1\end{ocg}}
\fi

\input msr-spolecne.tex

\makeatletter

\newcommand\QuestionsMulti[3][]{\def\msr@multi@what{\displayRandomizedQuestions}%
  \def\msr@save@itemsep{#1}%
  \def\msr@multi@opt{}\msr@multi@next{#2}{#3}}
\newcommand\AnswersMulti[3][]{\def\msr@multi@what{\displayRandomizedAnswers}%
  \def\msr@save@itemsep{#1}%
  \def\msr@multi@opt{\def\theenumi{\alph{enumi}}}\msr@multi@next{#2}{#3}}

\def\msr@jedna{1}
\newcommand\msr@multi@next[2]{%
  \def\msr@@temp{#1}\ifx\msr@@temp\empty\else {#1}\fi
  \def\temp{#2}
  \ifx\temp\msr@jedna \else \begin{multicols}{#2}\fi
    \msr@multi@opt
    \begin{enumerate}
    \ifx\msr@save@itemsep\empty\else \expandafter\itemsep\msr@save@itemsep\relax\fi
    \msr@multi@what
    \end{enumerate}
    \def\temp{#2}
    \ifx\temp\msr@jedna\else\end{multicols}\fi
}


\def\bezbodu{\expandafter\bezBodu\the}
{\catcode`p=12 \catcode`t=12 
\gdef\bezBodu#1pt{#1}}

\newbox\msr@sedybox
\newcommand\MSRincludegraphics[4]{%
\write\@auxout{\global\MsrObrazekStranka=\thepage}%
\pgfdeclareimage[interpolate=true,width=#1]{obrazek}{#4}%
\setbox0=\hbox{\pgfuseimage{obrazek}}%
\setbox\msr@sedybox=\hbox to 0 pt{\color{red}\vrule width \wd0 height \ht0 depth \dp0\hss}
\def\Xnum{#2}\def\Ynum{#3}%

\dimen0=\wd0
\divide\dimen0 by \Xnum
\edef\deltaX{\the\dimen0}%
\dimen0=\ht0
\divide\dimen0 by \Ynum
\edef\deltaY{\the\dimen0}%


  \begin{tikzpicture}[%
    path image/.style args={##1 shifted ##2 and ##3}{%
      path picture={ \node[anchor=north west,outer sep=0, inner sep=0] at
        ([shift={(-##2,##3)}]path picture bounding box.north west)
        {\pgfuseimage{##1}}; } }]

    \fill[gray!40] (0-\wd0+\Xnum*\deltaX,0+\deltaY) rectangle (\Xnum*\deltaX,-\Ynum*\deltaY+\deltaY);%\vbox to 0 pt{\box\msr@sedybox\vss}
    \foreach \x in {0,...,\Xnum}{ \foreach \y in {0,...,\Ynum}{%
        \pgfmathparse{random(\the\pocetOtazekHry)}%
        \def\jmeno{ta\pgfmathresult}%
        \dimen0=\deltaX
        \multiply\dimen0 by \x
        \edef\xx{\bezbodu\dimen0}%
        \dimen0=\deltaY
        \multiply\dimen0 by \y
        \edef\yy{\bezbodu\dimen0}
        \draw (\xx pt ,-\yy pt ) ++ (0.5*\deltaX, 0.5*\deltaY) node[pozadi] {\small ?}; 
        \begin{ocg}{\jmeno}{\jmeno}1%
          \path[path image=obrazek shifted
          \xx pt and \yy pt ]%Shifts the image
          (\xx pt ,-\yy pt ) rectangle
          +(\deltaX, \deltaY); %The size is the unit shift size
        \end{ocg}%
      } }
  \end{tikzpicture}%
}


\newcounter{msr@sparuj@pocitadlo}
\def\OTAZKY#1\par{\foreach \ot in  {#1} {\global\stepcounter{msr@sparuj@pocitadlo}%
\expandafter\toks\expandafter0\expandafter{\ot}%
\expandafter\xdef\csname OTAZKA CISLO \arabic{msr@sparuj@pocitadlo}\endcsname{\the\toks0}}}

\def\ODPOVEDI#1\par{\setcounter{msr@sparuj@pocitadlo}{0}\foreach \ot in  {#1} {\global\stepcounter{msr@sparuj@pocitadlo}%
\expandafter\toks\expandafter0\expandafter{\ot}%
\expandafter\xdef\csname ODPOVEDCISLO\Alph{msr@sparuj@pocitadlo}\endcsname{\the\toks0}}}

\def\msr@save@pair#1#2{%
\expandafter\let\expandafter\temp\csname OTAZKA CISLO #1\endcsname
\expandafter\def\expandafter\msr@first\expandafter{\temp}%
\expandafter\let\expandafter\temp\csname ODPOVEDCISLO#2\endcsname
\expandafter\def\expandafter\msr@second\expandafter{\temp}%
\expandafter\gdef\csname ODPOVED CISLO #2BYLA\endcsname{OdpovedByla}}

\def\msr@OdpovedByla{OdpovedByla}
\def\msr@relax{\relax}

\def\RESENI#1\par{\foreach \dvojice in {#1}{\expandafter\msr@save@pair\dvojice
\expandafter\expandafter\expandafter\otazka\expandafter\expandafter\expandafter{\expandafter\msr@first\expandafter}\expandafter{\msr@second}}
\foreach \msr@pocitadlo@fake in {A,...,U}
{\expandafter\ifx\csname ODPOVED CISLO \msr@pocitadlo@fake BYLA\endcsname\msr@OdpovedByla
\else \expandafter\ifx\csname ODPOVEDCISLO\msr@pocitadlo@fake\endcsname\relax\else
\expandafter\fake\expandafter{\csname ODPOVEDCISLO\msr@pocitadlo@fake\endcsname}\fi\fi
}
}



% Kod pro Otazky ve forme filmu
\if@msr@film



\begin{insDLJS}[initialize]{matchC}{JS Update of Matching Puzzle C}
this.resetForm(["ckbxQ"]);
activeQuestion = 1; 
this.getField("ckbxQ."+activeQuestion).value="Yes"; 
this.getField("ckbxQ").hidden=1; 
clearRedCrosses ();
zakryjocgZacinajici("SP");
odkryjocg("SP1");

function dalsi()
{
i=0;
this.resetForm(["ckbxQ"]);
if (hotovo==1)
{
  activeQuestion = activeQuestion + 1;
  if (activeQuestion == (\MSRpocetotazek+1)) {activeQuestion = 1;}
  zakryjocgZacinajici("SP");
  odkryjocg("SP"+activeQuestion);
}
else
{
do
{
  i = i+1;
  activeQuestion = activeQuestion + 1;
  if (activeQuestion == (\MSRpocetotazek + 1)) {activeQuestion = 1;}
  h = this.getField("ckbxQ."+activeQuestion);
}
while ((h.readonly) && (i<30) )
this.getField("ckbxQ."+activeQuestion).value="Yes"; 
zakryjocgZacinajici("SP");
odkryjocg("SP"+activeQuestion);
if (i>15) {zakryjocgZacinajici("SP");}
clearRedCrosses ();
}
}

function predchozi()
{
this.resetForm(["ckbxQ"]);
i=0;
if (hotovo==1)
{
  activeQuestion = activeQuestion - 1;
  if (activeQuestion == 0) {activeQuestion = \MSRpocetotazek;}
  zakryjocgZacinajici("SP");
  odkryjocg("SP"+activeQuestion);
}
else
{
do
{
  i=i+1;
  activeQuestion = activeQuestion - 1;
  if (activeQuestion == 0) {activeQuestion = \MSRpocetotazek;}
  h = this.getField("ckbxQ."+activeQuestion);
}
while ((h.readonly) && (i<30) )
this.getField("ckbxQ."+activeQuestion).value="Yes"; 
zakryjocgZacinajici("SP");
odkryjocg("SP"+activeQuestion);
if (i>15) {zakryjocgZacinajici("SP");}
clearRedCrosses ();
}
}

function checkForFinished(n,klic)
{
  dalsi();
  if (spusteno == 0)
  {
    spusteno=1;
    if (jmenoOCGs["tajenka"]!=null) {odkryjocg("tajenka");}
  }
    var f = this.getField("ckbxQ");
    var g = f.getArray();
    var anyEmpty = false;
    for ( var i=0; i < g.length; i++) {
        if ( (g[i].name != "puzzle.space") && (g[i].readonly == false) ) {
            anyEmpty = true;
            break;
        }
    }
    var nTotalPenaltyPoints=nMissed + nPenaltyPoints;
    if ( !anyEmpty ) {
        hotovo=1;
        var f = this.getField("ckbxA");
        if (f!=null) {f.readonly=true;}
        var f = this.getField("odpoved");
        if (f!=null) {f.readonly=true;}
        odkryjocg("SP0");
        stra = "\u0158e\u0161en\u00ed: "+klic;
        str = PocetChybMsg(nMissed);
        var f = this.getField("report.1");
        if (f!=null) {f.value = stra;} else {str = str + "\n\n" + stra;}
        var f = this.getField("report.2");
        if (f!=null) {f.value = str;}
        var P= (2* KonstPocetOdpovedi - KonstPocetOtazek + 1 ) * KonstPocetOdpovedi /2;
        var znamka = "5";
        if (nMissed <= 0.6 * ( P - KonstPocetOdpovedi )) znamka="4";
        if (nMissed <= 0.4 * ( P - KonstPocetOdpovedi )) znamka="3";
        if (nMissed <= 0.25 * ( P - KonstPocetOdpovedi )) znamka="2";
        if (nMissed <= 0.1 * ( P - KonstPocetOdpovedi )) znamka="1";
        if (nMissed <= 0.005 * ( P - KonstPocetOdpovedi )) znamka="0";
        odkryjocg("oblicej"+znamka);
        odkryjocg("hotovo");
        \MsrBublinaZpozdenaB
    }
    this.dirty=false;
}


for (var i = 1; i <= \MSRpocetotazek; i++){ zakryjocgZacinajici("q"+i);}


\end{insDLJS}


\makeatletter
\def\msr@film@prev{\pushButton[\A{\JS{predchozi();}}\CA{<<}\BC{}\BG{}]{dalsi}{1cm}{10pt}}
\def\msr@film@next{\pushButton[\A{\JS{dalsi();}}\CA{>>}\BC{}\BG{}]{dalsi}{1cm}{10pt}}
\let\saveMsrFilmPrev\msr@film@prev
\let\saveMsrFilmNext\msr@film@next

\def\obalit@msr@sparuj@film#1{\hbox to 0 pt{
    \begin{minipage}{0.95\sirkaSesitu}
      #1
    \end{minipage}
\hss}}

\renewcommand\QuestionsMulti[3][]{
\begin{equation*}
\leavevmode\obalit@msr@sparuj@film{\begin{ocg}{SP0}{SP0}1\ObalkaFilmu{}{}{Gratulujeme, hra je dokonèena. Nyní si mùžete zobrazit hodnocení nebo 
použít tlaèítka na okrajích k~opìtovnému listování otázkami.}\end{ocg}}
\multido{\i=1+1}{\MSRpocetotazek}{\leavevmode\obalit@msr@sparuj@film{\begin{ocg}{SP\i}{SP\i}1
      \ObalkaFilmu{\i}{\MSRpocetotazek}{\input{\jobname_q\i.cut}}
\end{ocg}}}%
\hbox to \sirkaSesitu{\hss} 
\end{equation*}
\vbox to 0 pt{\hbox to 0 pt{\vbox{\begin{enumerate}
 \displayRandomizedQuestions
\end{enumerate}}\hss}}
}

\newdimen \sirkaSesitu
\sirkaSesitu=12cm 
\newdimen \vyskaSesitu
\vyskaSesitu=2.8cm 

\newcommand\ObalkaFilmu[4][]{\setbox0=\hbox{\begin{minipage}{\linewidth}\def\temp{#2}\ifx\temp\empty\else\textbf{#2/#3:}\fi{} #4
      \end{minipage}}
\hspace*{-1cm}\tikz[x=\the\sirkaSesitu,y=\the\vyskaSesitu]{
\draw[fill=black!20, draw=black!20, rounded corners=5pt] (-0.5cm,0) rectangle (1,1);
\draw (0.5,1) node [below] {\box0};
\foreach \i in {0.1,0.366,0.633,0.9} {\draw[draw=black,fill=pozadi] (-0.1cm,\i) circle (3pt);%
\draw[yshift=\i * \the\vyskaSesitu,very thin,rotate=4,double=white,double distance=1.5pt](-0.1 cm,0) arc (40:-250:10pt and 2pt);}%
\draw (0,0) node [above right] {\saveMsrFilmPrev};
\draw (1,0) node [above left] {\saveMsrFilmNext};
}
}


\def\MSR@vsechny@otazky#1{#1}

\def\obalit@checkbox#1#2#3{\def\temp{#3}\ifx\temp\msr@test@A\setcounter{msr@test@count}{#2}\def\temp@msr@{\alph{msr@test@count}}\else\def\temp@msr@{#2}\fi
\hbox to 0 pt{\hss\hbox@sparuj{#1}\hss\ifx\temp\msr@test@A\lower 2pt\hbox@sparuj{\includegraphics{msr_testy_checkbox_gray.pdf}}\hss\fi
\ifx\temp\msr@test@A\lower 2pt\hbox@sparuj{\begin{ocg}{OD#2}{OD#2}0\includegraphics{msr_testy_checkbox_green.pdf}\end{ocg}}\fi
\ifx\temp\msr@test@A\hss\hbox@sparuj{\temp@msr@}\fi}}


\fi

%%% Local Variables: 
%%% coding: cp1250
%%% End: 



