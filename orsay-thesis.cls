%########################################################################
%
% Filename : orsay-thesis.cls
% Author   : Vincent Feuvrier
% Contact  : vincent.feuvrier@normalesup.org
% modified by CAI Caifang, le mai 2012
% modified by Weiya Chen, le septembre 2015
%
% Simple to use LaTeX class for writing thesis in sciense at
% Paris-Sud university.
%
% See included manual files for usage.
%
%########################################################################

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{orsay-thesis}[2010/03/03 Custom class for writing thesis in science at Paris-Sud University]

%########################################################################
% Options
%########################################################################
\RequirePackage{ifthen}
\RequirePackage{keyval}
\LoadClass[a4paper,twoside,12pt]{book}
\usepackage[plainpages=false,pdfpagelabels,colorlinks=true]{hyperref}
\hypersetup{
    citecolor=blue,%
    filecolor=blue,%
    linkcolor=blue,%
    urlcolor=blue
}
\def\@orsay@language{english}
\def\@orsay@babel@language{english}
\def\@orsay@select@language{%
  \expandafter\expandafter\expandafter\selectlanguage\expandafter\expandafter\expandafter{\@orsay@babel@language}%
}

\define@key{orsay-thesis}{mainlanguage}{%
  \gdef\@orsay@language{#1}%
  \ifthenelse{\equal{#1}{french}}{%
    \gdef\@orsay@babel@language{francais}%
  }{%
    \gdef\@orsay@babel@language{#1}%
  }%
}

\def\@orsay@languages{english,francais}
\define@key{orsay-thesis}{morelanguage}{%
  \edef\@orsay@languages{#1,\@orsay@languages}%
}

\newif\if@orsay@parttoc
\@orsay@parttocfalse
\define@key{orsay-thesis}{parttoc}[]{\@orsay@parttoctrue}

\newif\if@orsay@logos
\@orsay@logosfalse
\define@key{orsay-thesis}{logos}[]{\@orsay@logostrue}

\newif\if@orsay@lists
\@orsay@listsfalse
\define@key{orsay-thesis}{lists}[]{\@orsay@liststrue}

\let\@keyval@options@list\@empty
\def\@extract@key#1=#2\@extract@key{#1}

\def\ProcessKeyvalOptions#1{%
  \let\@tempa\@empty
  \let\@tempb\@empty
  \@for\CurrentOption:=\@keyval@options@list\do{%
    \expandafter\expandafter\expandafter\def\expandafter\expandafter\expandafter\@key\expandafter\expandafter\expandafter{%
      \expandafter\@extract@key\CurrentOption=\@extract@key%
    }%
    \@ifundefined{KV@#1@\@key}{\edef\@tempa{\@tempa,\CurrentOption,}}{\edef\@tempb{\@tempb,\CurrentOption,}}
  }%
  \@for\CurrentOption:=\@tempa\do{%
    \ifx\CurrentOption\@empty%
    \else%
      \PassOptionsToClass{\CurrentOption}{book}%
    \fi%
  }%
  \edef\@tempb{%
    \noexpand\setkeys{#1}{\@tempb}%
  }%
  \@tempb%
  \AtEndOfPackage{%
    \let\@unprocessedoptions\relax%
  }%
}

\DeclareOption*{%
  \expandafter\expandafter\expandafter\def\expandafter\expandafter\expandafter\@keyval@options@list\expandafter\expandafter\expandafter{%
    \expandafter\@keyval@options@list\expandafter,\CurrentOption%
  }%
}

\ProcessOptions\relax
\ProcessKeyvalOptions{orsay-thesis}%

%########################################################################
% Base class and packages
%########################################################################



%Language
\RequirePackage[\@orsay@languages,\@orsay@babel@language]{babel}
\RequirePackage{textcomp}
\RequirePackage[autolanguage]{numprint}

%Page setup

\RequirePackage[hmargin={2.5cm,2.5cm},vmargin={2.5cm,2.5cm}]{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage[avantgarde]{quotchap}
%Part table of contents
\def\@finalize@parttoc{%
  \if@orsay@doneparttoc%
  \else%
    \doparttoc%
    \faketableofcontents%
  \fi%
}
\if@orsay@parttoc%
  \AtEndDocument{\@finalize@parttoc}
  \RequirePackage{minitoc}

  \renewcommand\ptctitle{\summaryname}
%  \mtcsetdepth{parttoc}{3}
  \setcounter{tocdepth}{2}
  \newif\if@orsay@doneparttoc
  \@orsay@doneparttocfalse
  \let\@old@tableofcontents=\tableofcontents
  \def\tableofcontents{%
    \@orsay@doneparttoctrue%
    \doparttoc%
    \@old@tableofcontents%
  }
\fi

%Logos
\if@orsay@logos
\usepackage{graphicx}
\RequirePackage{ifpdf}
\fi

%Math
\RequirePackage{amsmath,amssymb,amsfonts}

%Misc
\RequirePackage{tabularx}

%########################################################################
% Lists and parts setup
%########################################################################

\newlength\defparindent
\newlength\defitemsep
\newlength\itemizesep
\newlength\itemizeparskip

\setlength\defparindent{20pt}
\setlength\parskip{0.5\baselineskip}
\setlength\itemizesep{0.3333\baselineskip}
\setlength\defitemsep\itemizesep
\setlength\itemizeparskip{0.25\baselineskip}

\AtBeginDocument{%
  \if@orsay@lists%
    \setlength\parindent\defparindent%
    \let\olditemize=\itemize%
    \renewenvironment{itemize}{%
      \olditemize%
      \addvspace{\itemizesep}%
      \setlength\itemindent{9pt}%
      \setlength\itemsep\defitemsep%
      \addtolength\itemsep{-\itemizeparskip}%
      \setlength\parskip\itemizeparskip%
      \setlength\parindent\defparindent%
    }{%
      \endlist%
      \addvspace{\itemizesep}%
    }%
    \let\oldenumerate=\enumerate%
    \renewenvironment{enumerate}{%
      \olditemize%
      \addvspace{\itemizesep}%
      \setlength\itemindent{8pt}%
      \setlength\itemsep\defitemsep%
      \addtolength\itemsep{-\itemizeparskip}%
      \setlength\parskip\itemizeparskip%
      \setlength\parindent\defparindent%
    }{%
      \endlist%
      \addvspace{\itemizesep}%
    }%
    \renewcommand\labelitemi{$\diamond$}%
    \renewcommand\labelitemii{$\star$}%
    \renewcommand\labelitemiii{-}%
  \fi%
  \let\@orsay@old@part=\@part%
  \let\@orsay@old@endpart=\@endpart
  \def\@endpart{}
  \let\beforeparttoc\empty
%\if@orsay@parttoc\vfill\doparttoc\fi%
     \def\@part[#1]#2{%
     \@orsay@old@part[#1]{#2}%
     \if@orsay@parttoc\parttoc\fi%
  %   \@orsay@old@endpart%
   }%
  %\if@orsay@parttoc\vfill\parttoc\fi%
  \renewcommand\sectionmark[1]{\markright{#1}\gdef\@orsay@current@section{#1}}%
  \renewcommand\subsectionmark[1]{\markboth{\thesubsection\ -\ \emph{#1}}{\@orsay@current@section}}%
}
%########################################################################
% Page setup
%########################################################################

\tolerance=10000
\hbadness=10000

\usepackage{psboxit}
\PScommands
\usepackage{fancyhdr}

%% first reset the headers and footers
\fancyhead{}
\fancyfoot{}
%% make the odd pages have the section name on the top right
\fancyhead[RO]{\sffamily\bfseries \rightmark}
%% make the even pages have the chapter name on the top left
\fancyhead[LE]{\sffamily\bfseries \leftmark}

%% page nums on the bottom in a nice box
%% even side pages
%\fancyfoot[LE]{\psboxit{box 0.8 setgray fill}
%{\framebox[10mm][c]{\rule{0cm}{4mm}\color{black}{\bfseries \thepage}}}}
%% odd side pages
%\fancyfoot[RO]{\psboxit{box 1 setgray fill}
%{\hspace{\textwidth}\psboxit{box 0.8 setgray fill}
%{\framebox[10mm][c]{\rule{0cm}{4mm}\color{black}{\bfseries \thepage}}}}}

%% page nums on the bottom without box
%% even side pages
\fancyfoot[LE]{\thepage}
%% odd side pages
\fancyfoot[RO]{\thepage}


%% make the bottom line above the page number box
\renewcommand{\footrulewidth}{0.4pt}
\renewcommand{\footruleskip}{0mm}
%% now redefine the plain style pages (chapter pages, contents pages)
%% to have the same page number stuff on the bottom
\fancypagestyle{plain}{
\fancyhf{}
%\fancyfoot[RO]{\psboxit{box 1 setgray fill}
%{\hspace{\textwidth}\psboxit{box 0.8 setgray fill}
%{\framebox[10mm][c]{\rule{0cm}{4mm}\color{black}{\bfseries \thepage}}}}}
\fancyfoot[RO]{\thepage}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0.5pt}
}
\usepackage[calcwidth]{titlesec}
\titleformat{\section}[hang]{\sffamily\bfseries}
 {\Large\thesection}{12pt}{\Large}[{\titlerule[0.5pt]}]
\setlength{\headheight}{15pt}
%% bring the style into effect
%% (must come after all the fancyhead and fancyfoot stuff)
\pagestyle{fancy}


%########################################################################
% Multilingual abstracts
%########################################################################

\def\keywordsname{Keywords}
\def\summaryname{Summary}

\addto\captionsfrench{%
  \renewcommand\keywordsname{Mots-clefs}%
  \renewcommand\summaryname{Sommaire}%
}

\addto\captionsenglish{%
  \renewcommand\keywordsname{Keywords}%
  \renewcommand\summaryname{Summary}%
}

\addto\captionsgerman{%
  \renewcommand\keywordsname{Schlagworte}%
  \renewcommand\summaryname{Inhaltsverzeichnis}%
}

\addto\captionsitalian{%
  \renewcommand\keywordsname{Keywords}%
  \renewcommand\summaryname{Indice}%
}

\newenvironment{abstract}[1][\@orsay@language]{%
  \edef\@orsay@current@abstract@language{#1}%
  \expandafter\expandafter\expandafter\selectlanguage\expandafter\expandafter\expandafter{#1}%
  \small%
  \setlength\parskip{0pt}%
  \parindent=\defparindent%
  \begin{center}%
    \ifthenelse{\equal{#1}{\@orsay@language}}{}{%
      \textsc{%
        \normalsize%
        \@ifundefined{@title@#1}{%
          \ClassError{orsay-thesis}{No title given for language "#1"}{Title for language "#1" is mandatory for this class. You should provide one using the title command.}%
        }{%
          \csname @title@#1\endcsname%
          \nopagebreak[4]%
          \\[1ex]%
        }%
      }%
    }%
    {\bfseries\abstractname}%
  \end{center}%
  \unskip%
  \medskip%
  \nopagebreak[4]%
  \par%
}{%
  \nopagebreak[4]%
  \\[\smallskipamount]%
  \nopagebreak[4]%
  \textbf{\uppercase{\keywordsname}} : %
  \@ifundefined{@keywords@\@orsay@current@abstract@language}{%
    \ClassError{orsay-thesis}{No keywords given for language "\@orsay@current@abstract@language"}{Keywords for language "\@orsay@current@abstract@language" are mandatory for this class. You should provide them using the keywords command.}%
  }{%
    \csname @keywords@\@orsay@current@abstract@language\endcsname.%
  }%
  \par%
  \@orsay@select@language%
}
%########################################################################
% Initialization
%########################################################################

\def\@title@french{???\ClassError{orsay-thesis}{No French title given}{French title is mandatory for this class. You should provide one using the \protect\title command.}}
\def\@title@english{???\ClassError{orsay-thesis}{No English thesis title given}{English title is mandatory for this class. You should provide one using the \protect\title command.}}
\def\@keywords@french{???\ClassError{orsay-thesis}{No French keywords given}{English keywords are mandatory for this class. You should provide them using the \protect\keywords command.}}
\def\@keywords@english{???\ClassError{orsay-thesis}{No English keywords given}{English keywords are mandatory for this class. You should provide them using the \protect\keywords command.}}
\def\@author{???\ClassError{orsay-thesis}{No author given}{The author is mandatory for this class. You should provide one using the \protect\author command.}}
\def\@specialty{???\ClassError{orsay-thesis}{No specialty is given}{The specialty is mandatory for this class. You should provide one using the \protect\specialty command.}}
\def\@affila{???\ClassError{orsay-thesis}{No affiliation is given}{The affiliation is mandatory for this class. You should provide one using the \protect\affil command.}}
%\def\@affiladd{???\ClassError{orsay-thesis}{No affiliation is given}{The affiliation is mandatory for this class. You should provide one using the \protect\affildd command.}}
\def\@date{??/??/??\ClassError{orsay-thesis}{No defense date given}{The defense date is mandatory for this class. You should provide one using the \protect\date command.}}
\def\@ordernumber{\ClassWarning{orsay-thesis}{No order number given}{The order number was not specified. You should provide one using the \protect\order command.}}
%%%%
%% this next section (till \makeatother) makes sure that blank pages
%% are actually completely blank, cause they're not usually
\makeatletter
\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else
	\hbox{}
	\vspace*{\fill}
	\thispagestyle{empty}
	\newpage
	\if@twocolumn\hbox{}\newpage\fi\fi\fi}
\makeatother