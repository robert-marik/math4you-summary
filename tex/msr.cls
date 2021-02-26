\ProvidesClass{msr}
\LoadClass{article}
\pdfoutput=1 

\RequirePackage{xkeyval,msr-skeletons}
\RequirePackage{msr-ocg-p,multido}

% Volba tiskne znacky ke spravnym odpovedim, pouziva se pri tvorbe a ladeni testu
\newif\if@msr@proofing\@msr@proofingfalse
\DeclareOptionX{proofing}{\@msr@proofingtrue}

\newif\if@msr@preview\@msr@previewfalse
\DeclareOptionX{preview}{\@msr@previewtrue\@msr@proofingtrue\def\MsrObrazekKoncovka{png}}

\newif\if@msr@answerfield\@msr@answerfieldfalse
\DeclareOptionX{answerfield}{\@msr@answerfieldtrue}

\newif\if@msr@noanswerfield\@msr@noanswerfieldfalse
\DeclareOptionX{noanswerfield}{\@msr@noanswerfieldtrue}

% Volba vlozi policko s poctem bodu na konec testu
\newif\if@msr@pointsfield\@msr@pointsfieldfalse
\DeclareOptionX{points}{\@msr@pointsfieldtrue}

\newif\if@msr@permutuj\@msr@permutujtrue
\DeclareOptionX{permutuj}{\@msr@permutujtrue}
\DeclareOptionX{nepermutuj}{\AtEndOfPackage{\Nepermutuj}}

\newif\if@msr@anone\@msr@anonefalse
\DeclareOptionX{anone}{\@msr@anonetrue\@msr@permutujfalse}

\DeclareOptionX{random}{\def\msr@randomi{#1}}

\def\MsrError#1#2#3{\PackageWarning{#1}{#2}}
\DeclareOptionX{final}{\let\MsrError\PackageError}

\DeclareOptionX{mrizka}{\AtEndOfClass{\RequirePackage[bl]{pagegrid}}}

\ProcessOptionsX
\if@msr@proofing
\PassOptionsToPackage{proofing}{exerquiz}
\fi

\usepackage{amsmath, xcolor}

\input msr-vzhled.tex
% grafika
\usepackage{graphicx}
\usepackage{pgf,tikz}
\usetikzlibrary{arrows}


% AcroTeX
% [2011/01/28 v2.5l Provides general eForms support (dps)]
% [2011/08/10 v6.4i Exerquiz: Exercises and Quizzes for LaTeX/PDF package (dps)]

\usepackage[czech,pdftex%,showgrayletters
]{exerquiz}


% Na posledni strance se shortquiz neni tlacitko pro prechod na dalsi stranku
 \let\ori@@aeb@endshortquiz\aeb@endshortquiz
 \def\aeb@endshortquiz{\ori@@aeb@endshortquiz\global\def\msr@jedno@tlacitko@next{%\msr@jedno@tlacitko{\Acrobatmenu{NextPage}}{next}
 }}



\renewcommand\eqQuizPointsMsg{%
  "\eqScore\space"+Math.max(ptScore,0)+" \eqOutOf\space"+nPointTotal}

\renewcommand\eq@OutOf{z celkových}
\renewcommand\eqsqrtmsg{"Správn\u011B!"}
\renewcommand\eqsqwgmsg{"\u0160patn\u011B!"}

\input msr-ocgs.tex
\if@msr@preview\else
\input msr-kontrolapluginu.tex
\fi

% Vzhled zatrhavacich tlacitek
% Zmeneny atributy \BC a textSize
% Radsi predefinovavam vsechno, protoze u testu jsou treba tri zaskrtavaci ctverecky pres sebe.
\def\Ans@c@f@Defaults
{%
    %\BC{0.3 0.4 0.18}
    \S{S}\W{1}\F{\FHidden}\textSize{10}
    \textColor{\solution@Color\space rg}\symbolchoice{circle}
}

\def\Ans@ck@f@Defaults
{%
    %\BC{0.3 0.4 0.18}
  \S{S}\W{1}\Ff{\FfNoToggleToOff}
  \textSize{10}\textColor{0 g}
}

\def\Ans@r@f@Defaults
{%
    %\BC{0.3 0.4 0.18}
  \S{S}\W{1}\Ff{\FfNoToggleToOff}
    \textSize{10}\textColor{0 g}
}

\def\@@Ans@sq@f@Defaults
{%
    %\BC{0.3 0.4 0.18}
  \Ff{\FfNoToggleToOff}
    \textSize{10}\textColor{0 g}
}

\def\Ans@r@l@Defaults
{%
    %\BC{0.3 0.4 0.18 }
  \S{S}\W{1}\Ff{\FfNoToggleToOff}
    \textSize{10}\textColor{0 g}\Ff{\FfReadOnly}
}

% Puvodni hlaseni nema pro testy v ramci MsR smysl (neni tlacitko spustit).

\renewcommand\eqInitQuizMsg{%
  "Test ji\u017E byl vyhodnocen. Chcete-li pracovat s testem od za\u010D\u00E1tku, mus\u00EDte jej zav\u0159\u00EDt a znovu otev\u0159\u00EDt."}


\definecolor{webgreen}{rgb}{0,0.5,0}
\usepackage{mi21}
\sqCorrections
\quiztype{f}


% Delka pro odsazeni. Bude mizet pri pouziti prostredi multicols a
% minipage, jinak bude nstavena na hodnotu, kterou nastavuje defaultne
% nadrazene prostredi blok. (Blok je totiz taky minipage a taky nuluje,
% proto ji musi po spusteni minipage nastavit na defaultni hodnotu.)
% Abychom mohli odsadit prostredi tabular, vlozime ho do minipage a
% posuneme o pozadovanou hodnotu doprava.

\newdimen \beforeanswerskip
\newdimen \msr@defult@beforeanswerskip
\msr@defult@beforeanswerskip=\parindent
\let\msr@savedmulticols\multicols
\def\multicols{\beforeanswerskip=0pt\relax\msr@savedmulticols}

\let\msr@savetabular\tabular
\let\msr@saveendtabular\endtabular
\def\tabular{\hskip \beforeanswerskip\begin{minipage}{\linewidth-\beforeanswerskip}\msr@savetabular}
\def\endtabular{\msr@saveendtabular\end{minipage}}
\let\msr@saveminipage\minipage
\def\minipage{\beforeanswerskip0pt\msr@saveminipage}

% Do makra \bChoices vpasuju \leftskip
\def\bChoices{\leftskip\beforeanswerskip\relax\@ifnextchar[{\@ansChoices}{\@ansChoices[\aeb@numCols]}}

% Ulozim si makro pro zacatky prostredi answers a manswers a vpasuju
% jim barvu. Jsou celkem 4 varianty answers/manswers versus
% quiz/shortzuiz

\let\msr@save@answers@q\answers@q
\def\answers@q{\color{odpovedcolor}%
    \if@msr@anone\else\if@msr@pointsfield\MsrError{msr}{Prostredi answers nemuze byt v testech s pocitanim bodu. ^^J Zamente za manswers nebo nepouzivejte volitelny parametr points}{Nepouzivejte volitelny parametr points}\fi\fi
    \msr@save@answers@q}
\let\msr@save@manswers@q\manswers@q
\def\manswers@q{\color{odpovedcolor}%
    \if@msr@anone\else\if@msr@pointsfield\else\MsrError{msr}{Prostredi manswers vyzaduje pocitani bodu. ^^J Zamente za answers pokud je jenom jedna spravna odpoved nebo pouzijte volitelny parametr points}{Pouzijte volitelny parametr points}\fi\fi
    \msr@save@manswers@q}
\let\msr@save@answers@sq\answers@sq
\def\answers@sq{\color{odpovedcolor}\msr@save@answers@sq}
\let\msr@save@manswers@sq\manswers@sq
\def\manswers@sq{\color{odpovedcolor}\msr@save@manswers@sq}
\def\prior@questionsHook{\color{odpovedcolor}}

% Vykopirovana definice prostredi questions, do ktere vpasujeme zmenu
% barvy (\color{odpovedcolor})
\renewenvironment{questions}
{%
    \ifnum\@eqquestiondepth>\tw@\@toodeep\else
    \advance\@eqquestiondepth\@ne\fi
    \vspace*{-10pt}%
    \def\@quesctr{eqquestionno\romannumeral\the\@eqquestiondepth}%
    \begin{list}{\qMark@Hook\prior@questionsHook\gdef\eqPTs{1}%
    \global\let\eqQT\eq@na%
    {\@tempcnta=0 \let\@thispr@b\@empty
     \@whilenum\@tempcnta<\@eqquestiondepth\do{\advance\@tempcnta\@ne
     \ifx\@thispr@b\@empty\edef\@thispr@b{%
     \csname theeqquestionno\romannumeral\the\@tempcnta\endcsname}\else
     \edef\@thispr@b{\@thispr@b%
     (\csname theeqquestionno\romannumeral\the\@tempcnta\endcsname)}\fi
    }\xdef\@currentQues{\@thispr@b}}%
    \makebox[\labelwidth][r]{\normalfont\bfseries
    \csname label\@quesctr\endcsname}\post@questionsHook
    }{\color{odpovedcolor}\usecounter{\@quesctr}%
    \settowidth{\labelwidth}{\normalfont\bfseries00.\ }%
    \setlength{\topsep}{3pt}\setlength{\parsep}{0pt}%
    \setlength{\itemindent}{0pt}\setlength{\itemsep}{3pt}%
    \setlength{\leftmargin}{\labelwidth}%
    \settowidth{\labelsep}{\ }}%
}{\end{list}}


% Na kazdou stranku pridame pole na odpovedi, pootocene o 90 stupnu,
% prilepene nastojato k pravemu okraji PDF souboru.
\if@msr@answerfield
\def\kazdastranka{\hbox to 0 pt{\hbox to \paperwidth {\hss\raise 24pt\hbox{\rotatebox{90}{\ifx\currQuiz\undefined\else\AnswerField[\rectW{10cm}\R{90}\BC{0 0 1}\F{\FHidden}]{\currQuiz}\fi}}\;}}}

\begin{insDLJS}[dljslibMSR]{dljslibMSR}{MSR}
function DisplayAnswer(fieldname,theanswer)
{
    ProcessIt = false;
    try {
    this.getField(fieldname).display=display.visible;
    this.getField(fieldname).strokeColor=color.transparent;
    this.getField(fieldname).value=("Odpoved: "+theanswer);
    } catch(e) {}
    ProcessIt = true;
}
\end{insDLJS}
\fi

% Zmìna definic tlaèítek pro zaèátek a konec testu a zobrazení
% oprav. Tlaèítka jsou neviditelná a prùhledná, pod nimi je text ukrytý
% v následujících makrech, mùže se jednat i o grafiku.

\def\msr@endquiztext{0}
\newcommand\@tlacitko[1]{\lower 9pt \hbox{\msr@konectestu{\includegraphics[width=3cm]{msr_vyhodnotit.pdf}}}}

\AtBeginDocument{
\setbox0=\hbox{\@tlacitko{\msr@endquiztext}}
\newdimen\vyskaEnd   \vyskaEnd\ht0 \advance\vyskaEnd by \dp0
\newdimen\sirkaEnd   \sirkaEnd\wd0
}

\if@msr@pointsfield\AtBeginDocument{\showCreditMarkup\definecolor{1}{rgb}{1,1,1}}\fi

\newdimen\MSRraise \MSRraise 2pt

\def\eq@EndQuizButtonDefaults {\AC{}\CA{}\H{O}\F{\FPrint}\BC{}\BG{}\W{1}\S{}}


\renewcommand\eq@EndQuizButton[1][]
{%
  \hypertarget{konec}{}%
  \ifx\eq@CGI\@empty
        \let\eq@submitURL=\@empty
        \let\eq@insertHiddenFields=\@empty
    \fi
    \push@@Button{#1}{endQuiz.\curr@quiz}{\MSRwidth}{\MSRheight}%
        {\eq@protect\A}{\eq@setButtonProps\eq@Button@driver}%
        {\eq@EndQuizButtonDefaults\eq@@EndQuizButtonActions
         \every@ButtonField\every@EndQuizButton}%
    \makebox[0pt][r]{\eq@insertHiddenFields}\gdef\eq@CGI{}%
}


% Puvodni definice: po pouziti \useBeginQuizButton je \eq@beginQuiz
% totez do \eq@BeginQuizButton. Pridame svoje vizualni prvky, totez pro tlacitko se koncem testu.

\renewcommand\eq@endQuiz{\hbox{\raise \MSRraise\hbox to 0pt {\@tlacitko{\msr@endquiztext}\hss}%
\def\MSRwidth{\the\sirkaEnd}%
\def\MSRheight{\the\vyskaEnd}%
\eq@EndQuizButton[]}\vfill}

\AtEndDocument{\immediate\write\@auxout{\string\gdef\string\MsRInfoWritten{1}}}
\def\zapisAuxQuiz{\immediate\write\@auxout{\string\gdef\string\MsRInfoQuizz{1}}}

\def\msr@konectestu#1{\begin{ocg}{konectestu}{konectestu}{1}#1\end{ocg}}

\def\msr@vloz@obliceje{}
\long\def\eq@prior@endQuiz{\par\penalty -10000\msr@vloz@obliceje\null\vskip -6\bigskipamount\msr@konectestu{\large \textbf{Konec testu}}\par\bigskip\leavevmode}


  % Pokud nechceme mit moc tlacitek pro ovladani testu, nechame test
  % spoustet automaticky pri zobrazeni prvni strany. V promenne
  % spustenoJMENO mame informaci, ze test JMENO je spusten.
  \renewcommand\eq@beginQuiz{%
    \zapisAuxQuiz
    \hypertarget{zacatek}{}%
    \ifx\if@msr@permutuj
     \edef\msr@temp@pageattr{}
    \else
     \edef\msr@temp@pageattr{/AA << /O << /S /JavaScript /JS (
      if ((!isQuizInitialized("\curr@quiz")) && (typeof(spusteno\curr@quiz)=="undefined")) 
      \string{\@initQuiz 
        var spusteno\curr@quiz=1; 
        var t = app.thermometer; 
        t.begin(); 
        t.text = "Probiha spousteni testu"; 
        var aOCGs = this.getOCGs(); 
        for(var i=0; aOCGs && i<aOCGs.length;i++) { if ( (aOCGs[i].name == "hodnoceni") || (aOCGs[i].name.substring(0,7) == "oblicej")) schovejocg(aOCGs[i].name);}
        this.dirty=false;
        t.end(); 
      \string}) >> >>}%
    \fi
    \expandafter\global\expandafter\pdfpageattr\expandafter{\msr@temp@pageattr /Group <</S /Transparency /I true /CS /DeviceRGB>>}}%

  % Tlacitko pro konec testu ponese napis "Vyhodnotit"
  \def\msr@endquiztext{5}

  % Tlacitko pro vyznaceni oprav neni potreba, opravy se vyznaci hned
  % po ukonceni testu, viz nize, definice makra
  % \eq@@EndQuizButtonActions a pridany radek correctQuiz

\if@msr@permutuj
  \def\msrAkceOdkrytiOCG{odkryjocg("oblicej"+znamka);odkryjocg("hodnoceni");schovejocg("konectestu");}
\else
  \def\msrAkceOdkrytiOCG{
    odkryjocg("hodnoceni");
    odkryjocg("oblicej"+znamka);
    schovejocg("konectestu");
  }
\fi


\def\eq@@EndQuizButtonActions
{%
    \A{\JS
        {if (!isQuizInitialized("\curr@quiz"))\jsR\jsT
            app.alert(InitMsg("\bqlabelISO"),3);\jsR
        else {\jsR\jsT
            if (\minQuizResp(\thequestionno)) {\jsR\jsT\jsT
                t.begin();
                t.text = "Probiha vyhodnocovani testu";
                if (typeof BodyMaximum =="undefined") {var BodyMaximum = \thequestionno;}
                DisplayQuizResults("\curr@quiz",BodyMaximum,%
\thequestionno);\jsR\jsT\jsT
                \eq@submitURL
                \postSubmitQuiz
                resetQuiz("\curr@quiz");\jsR\jsT
                f = this.getField("PercentField.\curr@quiz");
                if ( f != null) 
                {
                  var procenta = (100 * ptScore) / BodyMaximum;
                  if (procenta < 0) {f.value="0\%";}  
                }
                else
                {
                  var procenta = (100 * Score ) / \thequestionno;
                }
                var znamka = "5";
                if (procenta > 29) {znamka="4";}  
                if (procenta > 49) {znamka="3";}
                if (procenta > 69) {znamka="2";}
                if (procenta > 89) {znamka="1";}
                if (procenta > 99.5) {znamka="0";}
                \msrAkceOdkrytiOCG
                correctQuiz("\curr@quiz",\thequestionno);  % RM: Pridano opraveni testu
                this.getField("endQuiz.msr").hidden=true;
                t.end();
                this.dirty=false;
              }\jsR
            }}%
        }
      }


% Automaticky pridat policka s body a opravami na konec testu,
% zakazany strankovy zlom.
\long\def\konectestu{\nobreak\begin{minipage}{\linewidth}\color{black!80!white}\if@msr@pointsfield\par
Poèet správnì a úplnì zodpovìzených otázek: \ScoreField[\BC{}]\currQuiz

Získané body: \PointsField[\BC{}]\currQuiz 

Procento úspìšnosti: \PercentField[\BC{}]\currQuiz

\else

Poèet správných odpovìdí: \ScoreField[\BC{}]{\currQuiz}
\fi

Opravy byly vyznaèeny do testu. Pro jejich prohlédnutí se mùžete vrátit na pøedchozí stránky.
\end{minipage}}

\input random.tex
\ifx\msr@randomi\undefined\else \expandafter\randomi\msr@randomi\fi

\message{^^J Msr: Inicializace generatoru nahodnych cisel - \the\randomi ^^J}

\newcount\msr@hlaska
\def\msr@oblicej#1{%\vbox to 0 pt{\vss
% Nevim proc, ale nasledujici radek zlepsi nahodnost pri vyberu ksichtiku k hodnoceni otazek. Poprve se generator nahodnych cisel pouzije nanecisto. R.M.
\setrannum{\msr@hlaska}{1}{36}
\ifcase#1\relax\setrannum{\msr@hlaska}{1}{3}
\or\setrannum{\msr@hlaska}{1}{3}
\or\setrannum{\msr@hlaska}{1}{5}
\or\setrannum{\msr@hlaska}{1}{5}
\or\setrannum{\msr@hlaska}{1}{5}
\or\setrannum{\msr@hlaska}{1}{5}
\fi
\hbox to 0 pt{\hss\includegraphics[page=1, height=6cm]{msrhod#1\the\msr@hlaska _p.pdf}}%}
\message{^^J Hodnoceni #1, hlaska \the\msr@hlaska ^^J}%
}
\def\msr@obliceje@a@bubliny{\foreach \i in {0,1,2,3,4,5}{\begin{ocg}{oblicej\i}{oblicej\i}0\msr@oblicej{\i}\end{ocg}}\par}

\if@msr@preview
\else
  % Pokud neni aktivni parametr preview, predefinujeme konec testu tak, aby automaticky vkladal material patrici na konec testu
  \def\msr@vloz@obliceje{\bigskip\null\hfill\hbox{\msr@obliceje@a@bubliny}\par\vskip -3cm}

  \let\ori@@aeb@endquiz\aeb@endquiz
  \long\def\aeb@endquiz{\ori@@aeb@endquiz

    \bigskip
    \begin{ocg}{hodnoceni}{hodnoceni}0\konectestu\end{ocg}%
    }
\fi


% Vic mista okolo policek na zaskrtnuti, pridana \vrule do definice \Ans@tabular

\let\MSR@ori@Ans@tabular\Ans@tabular
\renewcommand\Ans@tabular{\leavevmode \vrule width 0 pt height 14 pt depth 4 pt\MSR@ori@Ans@tabular}

% \ifx\dljslibparams\undefined
% \usepackage{dljslib}
% \else
% \expandafter\usepackage\expandafter[\dljslibparams]{dljslib}
% \fi

% Prostredi blok zabrani strankovemu zlomu uvnitr otazky a odlomeni
% odpovedi na jinou stranku
\def\msrPredBlokem{}
\newskip\afterblokskip
\afterblokskip = 0 pt
\newenvironment{blok}{\msrPredBlokem\begin{minipage}{\linewidth}\beforeanswerskip=\msr@defult@beforeanswerskip\relax\color{otazkacolor}\item}{\end{minipage}\nobreak\vskip \afterblokskip\nobreak\vskip 12 pt plus 0.5 fill\nobreak\penalty0\nobreak\vskip 0 pt plus 1 fill \goodbreak
}

% Titulni strana
\AtBeginDocument{\maketitle\thispagestyle{empty}\newpage}

% U shortquiz nebude napis Kvíz
\renewcommand\eq@sqlabel{}
\renewcommand\sqlabel{\eq@sqlabel}

\if@msr@anone
\if@msr@pointsfield
  % Pro shortquiz: dve policka na konci radku s variantami odpovedi ano/ne
  \def\ano{\hfill\penalty0\hbox{}\nobreak\hfill\MSRobklopit{[1]1}{[-1]0}}
  \def\ne{\hfill\penalty0\hbox{}\nobreak\hfill\MSRobklopit{[-1]0}{[1]1}}
  
  \def\MSRobklopit#1#2{%
    \PTs{1}%
    {\begin{minipage}{1cm}%
        \kern -5pt
        \begin{answers}2\bChoices 
          \Ans#1\eAns
          \Ans#2\eAns
          \eChoices\end{answers}%
      \end{minipage}}}
\else
  % Pro shortquiz: dve policka na konci radku s variantami odpovedi ano/ne
  \def\ano{\hfill\penalty0\hbox{}\nobreak\hfill\MSRobklopit10}
  \def\ne{\hfill\penalty0\hbox{}\nobreak\hfill\MSRobklopit01}
  
  \def\MSRobklopit#1#2{%
    {\begin{minipage}{1cm}%
        \kern -5pt
        \begin{answers}2\bChoices 
          \Ans#1\eAns
          \Ans#2\eAns
          \eChoices\end{answers}%
      \end{minipage}}}
\fi
  
\def\legendaAnoNe{\leavevmode\null\hfill{\color{odpovedcolor} Ano Ne}\par\vspace*{6pt}\Nepermutuj}

\AtBeginDocument{\hideCreditMarkup}
\else % \if@msr@anone

\def\legendaAnoNe{\MsrError{msr}{Makro \string\legendaAnoNe\ pro testy Ano/Ne je mozne pouzivat ^^J jenom s volitelnym parametrem "anone" v documentclass.}{Pouzijte prosim volitelny parametr "anone".}}
\def\ano{\MsrError{msr}{Makro \string\ano pro testy Ano/Ne je mozne pouzivat ^^J jenom s volitelnym parametrem "anone" v documentclass.}{Pouzijte prosim volitelny parametr "anone".}}
\def\ne{\MsrError{msr}{Makro \string\ne pro testy Ano/Ne je mozne pouzivat ^^J jenom s volitelnym parametrem "anone" v documentclass.}{Pouzijte prosim volitelny parametr "anone".}}

\fi % \if@msr@anone

% pismenka vlozena volbou shograyletters jsou cerna (pro lepsi
% kontrast na interaktivni tabuli)
\definecolor{grayletters}{rgb}{0.5,0.5,0.5}
\def\insertGrayLetters{\rlap{\usebox{\msr@checkbox}}\ifaebshowgrayletters
    \rlap{\makebox[\RadioFieldSize]%
        {\textcolor{grayletters}%
          {\raise 1pt \hbox{\scriptsize\Alph{quizno}}}}}\else\relax\fi}

\newbox\msr@checkbox
\savebox\msr@checkbox{\lower 2.3pt\hbox{\kern-2.1pt\includegraphics{msr_testy_checkbox}}}

\immediate\pdfximage page 1{msr_tlacitka.pdf}%

\newcount\msr@ansbuttonimage
\msr@ansbuttonimage\the\pdflastximage

\everyCorrAnsButton{\CA{?????}\BG{}\BC{}\H{I}\mkIns{/TP 1 /I \the\msr@ansbuttonimage\space 0 R/IF<</A[1.0 1.0]/SW/A >>}  \TU{Klikni pro zobrazeni spravne odpovedi.}}

%Makro vykopirovane z exerquiz.sty. Pridana skupina a \DefaultHeightOfWidget. Pridano \if@corranstooltips

\def\eq@@@CorrAnsButton#1#2#3{%
    \def\CorrectAns{#2}\def\processJSfunc{#3}%
    \ifx\eqQuizType q\def\Fld@name{corr.\curr@quiz.\thequestionno}%
    \else\def\Fld@name{corr.\oField.\thequestionno}\fi
    {\def\DefaultHeightOfWidget{15bp}% RM
    \if@msr@noanswerfield% RM
    \def\ans@odpoved{\TU{Spravna odpoved: \CorrectAns \space\space\space\space}\A{\JS{app.alert("Spravna odpoved: \CorrectAns \space\space\space\space",3);}}}% RM
    \else% RM
    \def\ans@odpoved{}% RM
    \fi% RM
    \ifx\eqQuizType q%
        \edef\@@CorrAnsButtonActions{\noexpand\F{\FHidden}%
            \ifx\@qzsolndest\@empty\noexpand\BC{0 0 0}\else
            \noexpand\BC{\solution@Color}\fi
            \noexpand\A{\noexpand\qCorrAnsButtonActionHook}}%
        \ifeq@noquizsolutions\else
            \push@@Button{#1}{\Fld@name}{}{\DefaultHeightOfWidget}%
                {\eq@protect\A}{\eq@setButtonProps\eq@Button@driver}%
                {\CorrAnsButtonDefaults\@@CorrAnsButtonActions
                \every@ButtonField\every@CorrAnsButton\ans@odpoved}%
        \fi
    \else
        \edef\@@CorrAnsButtonActions{%
        \ifx\@qzsolndest\@empty\noexpand\BC{0 0 0}\else
        \noexpand\BC{\solution@Color}\fi
        \noexpand\A{\noexpand\sqCorrAnsButtonActionHook}}%
        \push@@Button{#1}{\Fld@name}{}{\DefaultHeightOfWidget}%
            {\eq@protect\A}{\eq@setButtonProps\eq@Button@driver}%
            {\CorrAnsButtonDefaults\@@CorrAnsButtonActions
            \every@ButtonField\every@CorrAnsButton\ans@odpoved}%
    \fi
  }%RM
}

\def\@maketitle{%
  \newpage
  \null
  \vskip 12em%
  \begin{center}%
  \let \footnote \thanks
    {\Large \textbf{\@title}\par}%

    \medskip
    \expandafter\ifx\csname msr@@obtiznost@\msr@obtiznost\endcsname\relax\else
    Test -- \csname msr@@obtiznost@\msr@obtiznost\endcsname
    \fi
  \end{center}%
  \hypertarget{home}{}
  \par
  \vfill
  {\centering 

    \begin{minipage}{0.75\linewidth}
      \ifx \MsRInfoWritten \undefined\else
        \ifx \MsRInfoQuizz \undefined

        Úkolem v testu je rozhodnout o pravdivosti uvedených
        tvrzení. Ihned po zakliknutí odpovìdi dojde k vyhodnocení. O
        správnosti odpovìdi budete informováni grafickým symbolem pøímo v
        oznaèeném políèku.  Další informace k ovládání testu naleznete
        na
        \href{http://msr.vsb.cz/napoveda/testy}{\color{odkaz}http://msr.vsb.cz/napoveda/testy}.

        \else
        \if@msr@pointsfield
        
        K nìkterým otázkám mùže existovat více správných odpovìdí. Otázka je
        zodpovìzena správnì, pokud jsou zatrženy právì všechny správné
        odpovìdi. Tlaèítko Vyhodnotit slouží k ukonèení testu, zobrazení
        výsledkù a správných odpovìdí. Další informace k ovládání testu
        naleznete na
        \href{http://msr.vsb.cz/napoveda/testy}{\color{odkaz}http://msr.vsb.cz/napoveda/testy}.
        
        \else % MsRInfoQuizz
        
        Pro každou otázku v testu existuje právì jedna správná odpovìï,
        kterou oznaèíte kliknutím na pøíslušné políèko. Tlaèítko
        Vyhodnotit slouží k ukonèení testu, zobrazení výsledkù a
        správných odpovìdí. Další informace k ovládání testu naleznete
        na
        \href{http://msr.vsb.cz/napoveda/testy}{\color{odkaz}http://msr.vsb.cz/napoveda/testy}.
        
        \fi % \if@msr@pointsfield
        \fi % \ifx \MsRInfoQuizz
        \fi % \ifx \MsRInfoWritten

    \end{minipage}

    \bigskip
    \vfill
    
    % \vtop to 0 pt{\vss\hbox{\VarovaniAcrobatReader}}
    
    \expandafter\ifx\csname \msr@autor\endcsname\relax
    \MsrError{msr}{Jmeno "\msr@autor" neni v databazi autoru, bud se jedna o preklep nebo je nutno doplnit databazi autoru.}{}
    Test byl vytvoøen v rámci projektu \href{http://msr.vsb.cz/}{\color{odkaz}Matematika s radostí}.
    \else
    Test byl vytvoøen v rámci projektu \href{http://msr.vsb.cz/}{\color{odkaz}Matematika s radostí} dle návrhu \csname \msr@autor\endcsname.
    \fi

    \bigskip
    \includegraphics[width=0.3\paperwidth]{OPVK_cb.pdf}
  
  }
  \newpage
}

\ptsLabel{b}
\ptLabel{b}
\rowsepDefault{4pt}

\def\RadioFieldSize{7bp}
\def\eq@textSize{9}

\definecolor{odpovedcolor}{rgb}{0.3,0.4,0.18}
\definecolor{otazkacolor}{rgb}{0.2,0.2,0.2}
\definecolor{msrblue}{rgb}{0.3,0.3,0.3}

%% vykopirovane z exerquiz, blue -> msrblue
%% barva a vzhled cisel u otazek

\renewcommand{\labeleqquestionnoi}{%
    \color{msrblue}\bfseries\theeqquestionnoi.}
\renewcommand{\labeleqquestionnoii}{%
    \color{msrblue}(\theeqquestionnoii)}
\renewcommand{\labeleqquestionnoiii}{%
    \color{msrblue}\bfseries(\theeqquestionnoiii)}

\if@msr@preview
\def\aeb@creditmarkupfmt{}
\else
\def\aeb@creditmarkupfmt{\makebox[0pt][r]{\raisebox{-10pt}[0pt][0pt]{\qMark\hspace{-5pt}}}}
\fi

\input msr-spolecne.tex

\def\starasablona{}
\newcommand\OdpovedBox{}
\newcommand\NepermutujKonec[1][1]{}
\newcommand\Nepermutuj{}
\newcommand\CentrovatNaOsu{}
\newcommand\ZarovnatNahoru{}
\makeatletter

\if@msr@anone \RequirePackage{msr-skeletons-anone} \expandafter\endinput\fi
\if@msr@permutuj\else \expandafter\endinput\fi

%%%%%%%% permutace po otevreni PDF

% Informace o spravnych vrstvach se zapise do souboru, vsechny otazky
% se TeXem oznaci jako spatne, potom ve v javascriptech nastavi
% spravnost (pozna se podle vlastnosti defaultIsChecked)

\newcount\msrPocetOtazek

% precteme pocet otazek a pocet variant odpovedi pro kazdou otazku
% pocet otazek je v \msrPocetOtazek, pocet variant i-te otazky v \csname pocetvari\endcsname
\def\OtazkaNepermutovatKonec#1#2{}
\def\OtazkaVariantaSpravnost#1#2#3{\msrPocetOtazek=#1\relax \expandafter\edef\csname pocetvar#1\endcsname{#2}}
\InputIfFileExists{\jobname.reseni}{}{}

\def\msrPoctyvariant{}
\def\msrSpravnost{}
\def\msrNepermutovat{}
% Inicializace poli pro pocet variant odpovedi v JS a pro uchovani sptavnosti
\Multido{\i=1+1}{\the\msrPocetOtazek}{\edef\msrPoctyvariant{\msrPoctyvariant pocetvariant[\i]=\csname  pocetvar\i\endcsname ; spravnost[\i] = [];}}

% Nacteni spravnosti variant odpovedi, budou v poli spravnost[otazka][varianta], hodnota je 0 nebo 1
\def\OtazkaVariantaSpravnost#1#2#3{\edef\msrSpravnost{\msrSpravnost spravnost[#1][#2]=#3; BodyMaximum = BodyMaximum +#3;}}
\def\OtazkaNepermutovatKonec#1#2{\edef\msrNepermutovat{\msrNepermutovat nepermutovatKonec[#1]=#2;}}
\InputIfFileExists{\jobname.reseni}{}{}


\begin{insDLJS}[nahodne]{nahodne}{MSRnahodnost}
// return a random permutation of a range (similar to randperm in Matlab)
function randperm(maxValue){
  // first generate number sequence
  var permArray = new Array(maxValue);
  for(var i = 0; i < maxValue; i++){
    permArray[i] = i;
  }
  // draw out of the number sequence
  for (var i = (maxValue - 1); i >= 0; --i){
    var randPos = Math.floor((i+1) * Math.random());
    if (randPos > i) {randPos = i;}
    var tmpStore = permArray[i];
    permArray[i] = permArray[randPos];
    permArray[randPos] = tmpStore;
  }
  return permArray;
}

odkryjocg("konectestu");

var t = app.thermometer; 
t.begin(); 
t.text = "Probiha inicializace testu ..."; 

var pocetvariant = new Array();
var spravnost = [];
var nepermutovatKonec = [];

\msrPoctyvariant

pocetotazek=\the\msrPocetOtazek;

for(var i=1; i <= pocetotazek ;i++) { nepermutovatKonec[i] = 0; }

\msrNepermutovat

var cojsemodkryl="";
p=new Array()
for(var i=1; i <= pocetotazek ;i++) 
{
  if (nepermutovatKonec[i] == 0)
  {
    p[i]=randperm(pocetvariant[i]);
  }
  else 
  {
    temp = pocetvariant[i]-nepermutovatKonec[i]+1;
    p[i]=randperm(temp-1);
    for (var j = temp; j<= pocetvariant[i]; j++ ) { p[i][j-1] = j-1;}
  }
  for (var j = 1; j<= pocetvariant[i]; j++ ) { jmeno=""+i+"-"+j+"-"+(p[i][j-1]+1) ; odkryjocg(jmeno); cojsemodkryl=cojsemodkryl+","+jmeno;}
}

var BodyMaximum=0; 
\msrSpravnost


for (i=1; i <= pocetotazek ; i++ )
{
  for (j=1; j <= pocetvariant[i] ; j++ )
  {
    f=this.getField("mcq.msr."+i+"."+j);
    if (f != null){
    if (spravnost[i][p[i][j-1]+1] == 1) 
    {
      f.defaultValue="Yes";
    }
    else
    {
      f.defaultValue="No";
    }
  }
  }
}


InitializeQuiz("msr",1);
var msr = new Object();
msr.oAlertCheck = { bAfterValue: false };
msr.Grp = {};
var spustenomsr=1; 
var aOCGs = this.getOCGs(); 
for(var i=0; aOCGs && i<aOCGs.length;i++) { if ( (aOCGs[i].name == "hodnoceni") || (aOCGs[i].name.substring(0,7) == "oblicej")) {schovejocg(aOCGs[i].name);}}

t.end(); 

this.dirty=false;

function ProcessMultiSelection(key,letterresp,probno,
    quizno,qtfield,pts,ppts) {
    newkey=spravnost[probno][(p[probno][(quizno-1)]+1)];   //RM
    if (newkey == 1) {ppts=1;} else {ppts=-1;}             //RM
    var f = this.getField("mcq."+qtfield+"."+probno);
    if ( ProbValue[probno] == null )  {
        var g = f.getArray();
        var nTotalCorrect = 0;
        for ( var i=0; i<g.length; i++)
            nTotalCorrect += (1*g[i].isDefaultChecked(0));
        ProbValue[probno] = new Array();
        RightWrong[probno] = new Array();
        ProbValue[probno] = [nTotalCorrect,pts,[]];
        RightWrong[probno][2] = new Array();
    } else var nTotalCorrect = ProbValue[probno][0];
    var fck = this.getField("mck."+qtfield+"."+probno+"."+quizno);
    if ( fck.isBoxChecked(0) ) {
        ProbValue[probno][2][quizno] = ppts;
        RightWrong[probno][2][quizno] = newkey;
    } else {
        ProbValue[probno][2][quizno] = null;
    }
    var pointsThisProblem=0;
    var scoreThisProblem = 0;
    var letterResponses = new Array();
    var areAllCorrect=1;
    var numCorrect=0;
    for ( var i=1; i< ProbValue[probno][2].length; i++ ) {
        if (ProbValue[probno][2][i] != null )
            letterResponses[i] = (String.fromCharCode(96+i));
        pointsThisProblem += ((ProbValue[probno][2][i]==null) ?
            0 : ProbValue[probno][2][i]);
        if ( (ProbValue[probno][2][i]!=null) ) {
            areAllCorrect *= (1*RightWrong[probno][2][i]);
            numCorrect +=(1*RightWrong[probno][2][i]);
        }
    }
    scoreThisProblem = areAllCorrect*numCorrect;
    var scoreThisProblem = Number( scoreThisProblem == nTotalCorrect );
    if (scoreThisProblem==1 && pointsThisProblem==0 )
        pointsThisProblem=pts;
    if (!negPointsAllowed)
        pointsThisProblem =
            (pointsThisProblem < 0) ? 0 : pointsThisProblem;
    ProbValue[probno][1] =
        ( (ProbValue[probno][1] == 0) && (scoreThisProblem == 1) )
            ? pts : pointsThisProblem;
    var passKey = ( pointsThisProblem > 0 ) ? 1 : 0;
    var retn = [ [ scoreThisProblem, passKey ], letterResponses ] ;
    return retn;
}

function ProcessQuestion (key,letterresp,probno,
    quizno,qtfield,notify,mark,msg) {
     if ( typeof key == "object" ) { newkey = key; }                 // RM
     else  { newkey=spravnost[probno][(p[probno][(quizno-1)]+1)];}   // RM
    var silent = ( arguments.length > 8 ) ? true : false;
    if (!isQuizInitialized(qtfield))
    {
        if (!silent) app.alert(InitMsg(msg),3);
        this.resetForm(["mc."+qtfield+"."+probno,
            "mck."+qtfield+"."+probno]);
    }
    else
    {
        ProcUserResp(newkey,letterresp,probno,notify);
        if (mark==1)
        {
            var f = this.getField("mcq."+qtfield+"."+probno);
            var fck = this.getField("mck."+qtfield+"."+probno);
            var bMultiSelect = ( fck != null ) ? true : false;
            f.delay=true;
            this.resetForm([f.name]);            
            var a = f.getArray();
            var l = a.length;
            if ( bMultiSelect ) {
                var ack = fck.getArray();
                for ( var i=0; i<l; i++) {
                    if ( ack[i].isBoxChecked(0)  ) {
                        a[i].style = ( a[i].isDefaultChecked(0) ) ?
                            style.ch : style.cr;
                        a[i].textColor = ( a[i].isDefaultChecked(0) ) ?
                            \checkColor : \crossColor;
                        a[i].value = "Yes";
                    } else {
                        a[i].style = ( a[i].isDefaultChecked(0) ) ?
                            style.ci : style.cr;
                        a[i].textColor = ( a[i].isDefaultChecked(0) ) ?
                            \checkColor : \crossColor;
                        a[i].value = ( a[i].isDefaultChecked(0) ) ?
                            "Yes" : "Off";
                    }
                }
            } else {
                for (var i=0; i < a.length; i++)
                    if (a[i].style == style.ch)
                    {
                        a[i].style = style.ci;
                        a[i].textColor = \correctColor;
                    }
                var qr=this.getField(
                    "mcq."+qtfield+"."+probno+"."+quizno);
                if (typeof app.formsVersion != "undefined"
                    && app.formsVersion >=4.0)
                    qr.textColor = newkey ? \checkColor\space :\crossColor;
                else
                    qr.fgColor = newkey ? \checkColor\space : \crossColor;
                qr.style = newkey ? style.ch : style.cr;
                qr.value="Yes"; // gr.checkThisBox(0);  // ver 5.0
            }
            this.getField("mcq."+qtfield+"."+probno).delay=false;
        }
    }
}

function ShortQuizSpravnost (row,col)
{
  if (spravnost[row][p[row][col-1]+1] == 1)
  {
    event.target.textColor=\correctColor;
    event.target.style=\correctStyle;
    var respMsg = \eqsqrtmsg;
  }
  else
  {
    event.target.textColor=\wrongColor;
    event.target.style=\wrongStyle;
    var respMsg = \eqsqwgmsg;
  }
}

\end{insDLJS}


\newwrite\MSRreseni
\immediate\openout\MSRreseni=\jobname.reseni

\newcount\msrPocetVariant
\newcount\msrpocitadlo

% priprava boxu pro odpovedi, maximalne 25 boxu
\multido{\i=1+1}{25}{\expandafter\newsavebox\expandafter{\csname varianta\i\endcsname}}

\let\msr@bChoices\bChoices

% Makra pro zjisteni, zda je odpoved spravna
\newcommand\removeOptSecond[2][]{}
\newcommand\removeOpt[1][]{\saveRest}
\def\removetwo#1{\removeOptSecond}
\def\savetwo #1{\removeOpt}
\long\def\saveRest#1#2;;koneec;;{\gdef\savedsecond{#1}}

\def\jedna{1}
\newdimen \@sirka@odpovedi
\newdimen \msr@labelwidth

\def\symbol@spravne@odpovedi{}
\if@msr@proofing
\def\symbol@spravne@odpovedi{\leavevmode\hbox to 0 pt{\hss\color{blue}$\bullet$\quad\ }\color{blue}}
\fi

\def\msr@star@test{*}
\newcount\msr@count@kolik@nepermutovat
\renewcommand\NepermutujKonec[1][1]{\def\msr@kolik@nepermutovat{#1}\msr@count@kolik@nepermutovat=#1\relax}
\renewcommand\Nepermutuj{\def\msr@kolik@nepermutovat{*}}
\let\msr@kolik@nepermutovat\relax

\newif\if@msr@centrovat@na@osu  
\@msr@centrovat@na@osufalse
\def\CentrovatNaOsu{\@msr@centrovat@na@osutrue}

\newif\if@msr@zarovnat@nahoru
\@msr@zarovnat@nahorufalse
\def\ZarovnatNahoru{\@msr@zarovnat@nahorutrue}

\newbox\msr@trybox
\newdimen\msr@tryboxdimen
\def\testrelax{\Ans\relax}
\newdimen\ZkraceniOdpovedi
\ZkraceniOdpovedi=0pt

\long\def\ulozitvariantu#1\eAns{\def\@@@temp{#1}\ifx\@@@temp\testrelax\def\msr@next{\relax}\else\toks0={#1}%
\advance\msrpocitadlo by 1 
\msrPocetVariant=\msrpocitadlo
\savetwo #1;;koneec;;
\expandafter\toks\expandafter1\expandafter{\savedsecond}
\@sirka@odpovedi=\linewidth
\settowidth{\msr@labelwidth}{\normalfont\bfseries00.\ \ }%
\advance\@sirka@odpovedi by -\msr@labelwidth\relax
\advance\@sirka@odpovedi by -\ZkraceniOdpovedi\relax
\expandafter\global\expandafter\sbox\expandafter{\csname varianta\the\msrpocitadlo\endcsname}{%
\OdpovedBox{{\ifx\savedsecond\jedna\symbol@spravne@odpovedi\fi\setbox\msr@trybox=\hbox{\begin{minipage}[t]{\@sirka@odpovedi}
      \removetwo #1
    \end{minipage}}\msr@tryboxdimen=\ht\msr@trybox \advance\msr@tryboxdimen by \dp\msr@trybox  
  \if@msr@centrovat@na@osu $\vcenter{\box\msr@trybox}$\else
  \ifdim \msr@tryboxdimen<50pt \vtop{\box\msr@trybox}\else 
  \if@msr@zarovnat@nahoru \vtop{\box\msr@trybox}\else $\vcenter{\box\msr@trybox}$\fi
  \fi\fi
}}}%
\immediate\write\MSRreseni{\string\OtazkaVariantaSpravnost{\thequestionno}{\the\msrpocitadlo}{\savedsecond}}%
\let\msr@next\ulozitvariantu\fi\msr@next}

\def\bChoices{\msrpocitadlo=0\let\msr@saveAns\Ans
\immediate\write\MSRreseni{^^J}%
\@ifnextchar[{\msr@ansChoices}{\msr@ansChoices[\aeb@numCols]}}

% tento prikaz se pravdepodobne nikde nepouziva
\newcommand\msr@Ans@save[2][1]{\def\msrSpravnost{#2}\def\body{#1}\msr@Ans@save@box}

\newcount\msrPocetVariantPermutovanych

\long\def\msr@ansChoices[#1]#2\eChoices{%
\ulozitvariantu #2\Ans\relax\eAns
\ifx\msr@kolik@nepermutovat\msr@star@test \msr@count@kolik@nepermutovat = \msrPocetVariant\relax \advance\msr@count@kolik@nepermutovat by -1\fi
\msrPocetVariantPermutovanych=\msrPocetVariant\relax
\advance\msrPocetVariantPermutovanych by -\msr@count@kolik@nepermutovat
\toks0={\msr@bChoices[#1]}%
\Multido{\i=1+1}{\the\msrPocetVariantPermutovanych}{\edef\temp{\toks0{\the\toks0 \noexpand\Ans0\noexpand\msr@vrstvy{\i}{\the\msrPocetVariantPermutovanych}\noexpand\eAns}}\temp}%
\advance\msrPocetVariantPermutovanych by 1
\Multido{\i=\the\msrPocetVariantPermutovanych+1}{\the\msr@count@kolik@nepermutovat}{\edef\temp{\toks0{\the\toks0 \noexpand\Ans0\noexpand\msr@vrstva{\i}\noexpand\eAns}}\temp}%
\ifx\msr@kolik@nepermutovat\relax\else\immediate\write\MSRreseni{\string\OtazkaNepermutovatKonec{\thequestionno}{\the\msr@count@kolik@nepermutovat}} \fi
\let\Ans\msr@saveAns \the\toks0
\eAns\eChoices}


\if@msr@preview
\def\msr@pocatecni@viditelnost{1}
\else
\def\msr@pocatecni@viditelnost{0}
\fi

% Makro vytvori na miste odpovedi skryte vrstvy se vsemi
% variantami. Jedna z variant bude vylosovana pri otevreni PDF souboru
\def\msr@vrstvy#1#2{\leavevmode\multido{\I=1+1}{#2}{\hbox to 0 pt{\,\begin{ocg}{\thequestionno-#1-\I}{\thequestionno-#1-\I}\msr@pocatecni@viditelnost 
\expandafter\usebox\expandafter{\csname varianta\I\endcsname}\end{ocg}\hss}}}

% Makro vytvori na miste odpovedi skrytou vrstvu s odpovedi. Tato
% odpoved se odkryje pri otevreni PDF souboru.
\def\msr@vrstva#1{\leavevmode{\hbox to 0 pt{\,\begin{ocg}{\thequestionno-#1-#1}{\thequestionno-#1-#1}\msr@pocatecni@viditelnost
\expandafter\usebox\expandafter{\csname varianta#1\endcsname}\end{ocg}\hss}}}


%% Uprava pro shortquiz

\def\Ans@sq@f@Actions
{%
    \A{\JS{ShortQuizSpravnost(\thequestionno,\arabic{quizno}); } }%
}

\def\PTs#1{}

%%% Local Variables: 
%%% coding: cp1250
%%% End: 

