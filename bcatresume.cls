% Copyright © 2010-11 Jonathan Rascher.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bcatresume}[2012/01/05 Jonathan Rascher's custom resume class]

% The body of the resume is set in Minion Pro, a rather small font. As such, we
% choose to typeset the resume at 12pt instead of the default 10pt size. By
% loading the standard LaTeX class option file here, we also get some nice
% default list settings.
\input{size12.clo}

% Load general purpose packages: ``fixltx2e'' to correct deficiencies in the
% default LaTeX format, and ``etoolbox'' to provide easy access to the enhanced
% features of e-TeX.
\RequirePackage{fixltx2e,etoolbox}

% Enable additional graphics commands. (We need this for ``\reflectbox''.)
\RequirePackage{graphicx}

% LaTeX uses fairly large margins by default. This leads to very nice pages
% when the document being typeset consists on large blocks of flowing text. On
% a resume, however, it looks too sparse. We fix that by shrinking the margins.
\RequirePackage[letterpaper,hmargin=0.9in,vmargin=1.4in]{geometry}

% Enable multi-column typesetting, and make the default column gap wider.
\RequirePackage{multicol}
\deflength\columnsep{.275in}

% Load the ``fontspec'' package to allow the use of OpenType fonts, the
% ``microtype'' package to enable automatic microtypographic adjustments, and
% the ``soul'' package to support letterspacing in LuaTeX.
\RequirePackage{fontspec,microtype,soul}

% Set up some nice fonts. You can download or purchase them here:
%   * <http://new.myfonts.com/fonts/adobe/minion/>
%   * <http://friedrichalthausen.de/?page_id=411>
\setmainfont[
  Ligatures=TeX,
  Numbers=OldStyle,
  FeatureFile=minion-pro.fea,
]{Minion Pro}
\newfontfamily\fancyfamily[Ligatures=TeX]{Fertigo Pro}

% Define macros that print the Minion Pro ornament with the specified index.
% The ``\nrom'' macro is a mirrored version of ``\morn'', which is useful for
% placing asymmetric glyphs on both sides of some text.
\newcommand*\bcatresume@ornament[1]{%
  \rmfamily\addfontfeature{RawFeature={+ornm=#1}}%
  •%
}
\newrobustcmd*\morn[1]{\mbox{\bcatresume@ornament{#1}}}
\newrobustcmd*\nrom[1]{\reflectbox{\bcatresume@ornament{#1}}}

% Record the Fertigo Pro family name so we can test the current font later on.
\begingroup
  \fancyfamily
  \global\let\bcatresume@fancyfamily\f@family
\endgroup

% Enable custom headers and footers, and allow detection of the total number of
% pages in the resume.
\RequirePackage{fancyhdr,lastpage}

% Set up page numbering and use our custom headers/footers.
\pagenumbering{arabic}
\pagestyle{fancy}

% Customize the resume's header/footer style.
\fancyhf{}
\cfoot{%
  \fancyfamily\footnotesize
  {\normalsize\nrom{13}}%
  \hspace{.5em}%
  \thepage\ of \pageref*{LastPage}%
  \hspace{.5em}%
  {\normalsize\morn{13}}%
}
\renewcommand*\headrulewidth{\z@}
\renewcommand*\footrulewidth{\z@}

% Allow the use of colored text.
\RequirePackage[dvipsnames]{xcolor}

% Enable various PDF enhancements. Note that the ``hyperref'' package redefines
% a bunch of core LaTeX stuff; thus it should be loaded after all other class
% processing is done.
\AtEndOfClass{
  \RequirePackage{hyperref}

  % Set general PDF options. (Resume-specific metadata is not specified till
  % the resume's title is typeset.)
  \hypersetup{
    colorlinks,
    allcolors=RawSienna,
    pdfpagemode=UseNone,
    pdfstartview=FitH,
    pdfprintscaling=None,
  }
}

% Make overfull boxes really ugly and noticeable.
\deflength\overfullrule{5\p@}

% Restore some default settings from the ``article'' class.
\deflength\lineskip{\p@}
\normallineskip\lineskip
\renewcommand*\baselinestretch{}

\@lowpenalty51
\@medpenalty151
\@highpenalty301

% Make the default enumerate and itemize environments actually useful.
% (The standard document classes do this for us, but we don't include a
% standard class, so...)
%
% These have been taken from the ``article'' class and tweaked a bit.
\deflength\leftmargini{2.5em}
\deflength\leftmarginii{2.2em}
\deflength\leftmarginiii{1.87em}
\deflength\leftmarginiv{1.7em}
\deflength\leftmarginv{1em}
\deflength\leftmarginvi{1em}

\@beginparpenalty-\@lowpenalty
\@endparpenalty-\@lowpenalty
\@itempenalty-\@lowpenalty

\deflength\labelsep{.5em}
\deflength\labelwidth{\leftmargini-\labelsep}

\renewcommand*\theenumi{\@arabic\c@enumi}
\renewcommand*\theenumii{\@alph\c@enumii}
\renewcommand*\theenumiii{\@roman\c@enumiii}
\renewcommand*\theenumiv{\@Alph\c@enumiv}

\newcommand*\labelenumi{\theenumi.}
\newcommand*\labelenumii{(\theenumii)}
\newcommand*\labelenumiii{\theenumiii.}
\newcommand*\labelenumiv{\theenumiv.}

\renewcommand*\p@enumii{\theenumi}
\renewcommand*\p@enumiii{\theenumi(\theenumii)}
\renewcommand*\p@enumiv{\p@enumiii\theenumiii}

\newcommand*\labelitemi{\morn{29}}
\newcommand*\labelitemii{\morn{26}}
\newcommand*\labelitemiii{\morn{27}}
\newcommand*\labelitemiv{\morn{0}}

\newcommand*\bcatresume@enumitem@sep{\itemsep\z@skip}
\appto\enumerate{\bcatresume@enumitem@sep}
\appto\itemize{\bcatresume@enumitem@sep}

% Set the default paragraph indent so that paragraphs line up with lists, and
% widen the spacing between non-list paragraphs, lists, and list items slightly.
\parindent\leftmargini
\deflength\parskip{2\p@ \@plus \p@}
\appto\@listi{\itemsep\glueexpr\itemsep+2\p@\relax}
\let\@listI\@listi

% Define formatting macros for topic lists.
\newcommand*\bcatresume@topic@labelfmt{\scshape\small\raise.125ex}

% Set up a list environment for rendering resume topics. Each list item
% indicates a new topic, which may be given a descriptive name. Paragraphs
% within the same topic are spaced much closer together than items in distinct
% topics. This breaks the paragraphs into per-topic ``chunks'' for easy
% reading.
%
% This environment is loosely based (in appearance and implementation) on the
% environment of the same name in the ``simplecv'' class.
\newcommand*\bcatresume@topic@label[1]{%
  \bcatresume@topic@labelfmt
  \hbox{#1}%
  \hfil
}

\newenvironment{topic}{%
  \list{}{%
    \let\makelabel\bcatresume@topic@label
    \deflength\parsep{.5\parsep}%
    \deflength\topsep{\topsep+\parsep}%
    \deflength\itemsep{\itemsep+\parsep}%
    \deflength\leftmargin{.275\columnwidth+\leftmargini}%
    \labelsep\columnsep
    \deflength\labelwidth{\leftmargin-\leftmargini-\labelsep}%
  }%
}{\endlist}

% Define macros to typeset ornaments in keyword lists.
\newcommand*\bcatresume@key@left{\morn{26}\hspace{.9em}}
\newcommand*\bcatresume@key@mid{\hspace{.9em}\morn{29}\hspace{.9em}}
\newcommand*\bcatresume@key@right{\hspace{.9em}\morn{26}}

% Set up an environment that typesets a list of keywords, separated by
% delimiters, with automatic line wrapping and support for different delimiters
% before the first keyword on a line, between keywords in a line, and after the
% last keyword on a line.
%
% These keyword lists use TeX's discretionary hyphenation support internally,
% and credit for this approach goes to the user Ant on the TeX StackExchange.
% See Ant's original post here: <http://tex.stackexchange.com/a/35286/1301>.
\newcommand*\bcatresume@key@nl{%
  \bcatresume@key@right
  \bcatresume@key@oldnl
  \togglefalse{bcatresume@key@inline}%
}

\newcommand*\bcatresume@key@pre{%
  \iftoggle{bcatresume@key@inline}{%
    \discretionary{%
      \mbox{\bcatresume@key@right}%
    }{%
      \mbox{\bcatresume@key@left}%
    }{%
      \mbox{\bcatresume@key@mid}%
    }%
  }{\mbox{\bcatresume@key@left}}%
}

\newcommand*\keyitem[1]{%
  \bcatresume@key@pre
  \toggletrue{bcatresume@key@inline}%
  \mbox{#1}%
  \ignorespaces
}

\newenvironment{keylist}{%
  \newtoggle{bcatresume@key@inline}%
  \let\bcatresume@key@oldnl\\
  \let\\\bcatresume@key@nl
  \list{}{%
    \rightmargin\leftmargin
    \labelwidth\z@
    \deflength\baselineskip{\baselineskip+\parsep}%
  }%
  %
  \centering\item\vspace{-\parsep}%
}{\mbox{\bcatresume@key@right}\endlist}

% Define macros to set title contents.
\newrobustcmd*\name{\gdef\bcatresume@name}
\newrobustcmd*\email{\gdef\bcatresume@email}
\newrobustcmd*\phone{\gdef\bcatresume@phone}
\newrobustcmd*\addrone{\gdef\bcatresume@addrone}
\newrobustcmd*\addrtwo{\gdef\bcatresume@addrtwo}
\newrobustcmd*\addrlast{\gdef\bcatresume@addrlast}

% Define formatting commands for the left, middle, and right portions of the
% resume title, respectively.
\newcommand*\bcatresume@leftfmt{\small}
\sodef\bcatresume@midfmt{\Large}{.3\p@}{\z@}{\z@}
\newcommand*\bcatresume@rightfmt{\small}

% Define a macro that typesets the resume's title.
\newcommand*\maketitle{
  % Make sure the resume's author specified their name.
  \ifundef\bcatresume@name{%
    \ClassError{bcatresume}{%
      No ``\protect\name'' command before ``\protect\maketitle''%
    }{}%
  }{}%
  % Set up PDF title and authorship information appropriately.
  \hypersetup{
    pdftitle=\bcatresume@name's Resume,
    pdfauthor=\bcatresume@name,
  }%
  % Print out the title itself.
  \begingroup
    \parindent\z@
    \parskip\z@skip
    \fancyfamily
    %
    \begin{minipage}{.3\linewidth}
      \raggedright
      \begin{tabular}{@{\bcatresume@leftfmt}l}
        \ifundef\bcatresume@email{}{%
          <\href{mailto:\bcatresume@email}{\bcatresume@email}> \\
        }%
        \ifundef\bcatresume@phone{}{\bcatresume@phone \\}
      \end{tabular}
    \end{minipage}%
    %
    \begin{minipage}{.4\linewidth}
      \centering\bcatresume@midfmt\bcatresume@name
    \end{minipage}%
    %
    \begin{minipage}{.3\linewidth}
      \raggedleft
      \begin{tabular}{@{\bcatresume@rightfmt}l}
        \ifundef\bcatresume@addrone{}{\bcatresume@addrone \\}%
        \ifundef\bcatresume@addrtwo{}{\bcatresume@addrtwo \\}%
        \ifundef\bcatresume@addrlast{}{\bcatresume@addrlast \\}%
      \end{tabular}
    \end{minipage}%
  \endgroup
  %
  \bigskip\bigskip\bigskip
  %
  \@afterindentfalse\@afterheading\par
}

% Define sectioning commands. Resumes should be short and simple, so we don't
% bother with more than a single sectioning level.
\setcounter{secnumdepth}{0}
\setcounter{tocdepth}{1}

\newcounter{section}
\renewcommand*\thesection{\@arabic\c@section}

\newcommand\section{%
  \@startsection{section}{1}{\z@}{-5.5\smallskipamount}{3\smallskipamount}{%
    \fancyfamily
  }%
}

% Define a command to format school/work experience lists.
\newcommand*\job[2]{#1\hspace{.36em}\morn{22}\hspace{.315em}\textit{#2}}

% Define a macro that typesets a hyphen while prohibiting a line break at that
% point. The empty horizontal space is necessary to permit normal hyphenation
% in the word following the dash.
\newcommand*\nbds{\texorpdfstring{\nobreakdashes-\hspace{\z@}}{-}}

% Typeset Fertigo Pro's ampersand in italics for additional prettiness. (Don't
% give the same treatment to Minion Pro, however. Minion's italic ampersand
% looks too ornate in roman text.)
\newcommand*\amp{%
  \texorpdfstring{%
    \begingroup
      \ifdefstrequal{\f@family}{\bcatresume@fancyfamily}{\itshape}{}%
      \&%
    \endgroup
  }{\&}%
}

% Lower the slash and kern it more tightly to improve the appearance of
% in-text fractions with old-style numerals.
\newcommand*\fracslash{%
  \texorpdfstring{\kern.01em\raisebox{-.23ex}{/}\kern-.05em}{/}%
}

% Tweak the kerning of unusual programming language names.
%
% XXX: Use lining hash sign instead of ``\raisebox''?
\newcommand*\CPP{%
  \texorpdfstring{%
    C\nolinebreak\kern-.02em%
    \raisebox{.17ex}{+\nolinebreak\kern-.1em+}%
  }{C++}%
}
\newcommand*\CS{%
  \texorpdfstring{C\nolinebreak\kern.032em\raisebox{.23ex}{\#}}{C\#}%
}
\newcommand*\FS{%
  \texorpdfstring{F\nolinebreak\kern.028em\raisebox{.22ex}{\#}}{F\#}%
}

% Define a wrapper for ``\patchcmd'' that properly handles macros defined using
% ``\DeclareRobustCommand'' and that automatically throws an error if patching
% fails. See here for inspiration: <http://tex.stackexchange.com/q/24245/1301>.
\newrobustcmd*\bcatresume@patch[3]{%
  \ifdefltxprotect#1{%
    \let\bcatresume@patch@space\space
  }{%
    \let\bcatresume@patch@space\@empty
  }%
  \edef\bcatresume@patch@cmd{%
    \expandafter\noexpand\csname
      \expandafter\@gobble\string#1\bcatresume@patch@space
    \endcsname
  }%
  \expandafter\patchcmd\bcatresume@patch@cmd{#2}{#3}{}{%
    \ClassError{bcatresume}{Couldn't patch ``\protect#1'' command}{}%
  }%
}

% Fix the LaTeX logo for Minion Pro.
\bcatresume@patch\LaTeX{\kern-.36em}{\kern-.28em}  % Kern between L and A
\bcatresume@patch\LaTeX{\kern-.15em}{\kern-.11em}  % Kern between A and T
\bcatresume@patch\TeX{\kern-.1667em}{\kern-.15em}  % Kern between T and E
\bcatresume@patch\TeX{\lower.5ex}{\lower.3667ex}   % Vertical shift of E
\bcatresume@patch\TeX{\kern-.125em}{\kern-.09em}   % Kern between E and X
