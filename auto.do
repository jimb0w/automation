
texdoc init auto, replace logdir(auto_log) gropts(optargs(width=0.8\textwidth))
set linesize 100

*ssc install texdoc, replace
*net from http://www.stata-journal.com/production
*net install sjlatex
*copy "http://www.stata-journal.com/production/sjlatex/stata.sty" stata.sty

texdoc stlog, nolog nodo
cd /home/jimb0w/Downloads/tempauto/
texdoc do auto.do
exit
texdoc stlog close

/***

\documentclass[11pt]{article}
\usepackage{fullpage}
\usepackage{siunitx}
\usepackage{hyperref,graphicx,booktabs,dcolumn}
\usepackage{stata}
\usepackage[x11names]{xcolor}
\bibliographystyle{unsrt}
\usepackage{natbib}
\usepackage{pdflscape}
\usepackage[section]{placeins}
\usepackage{amssymb}

\usepackage{chngcntr}
\counterwithin{figure}{section}
\counterwithin{table}{section}

\usepackage{multirow}
\usepackage{booktabs}

\newcommand{\specialcell}[2][c]{%
  \begin{tabular}[#1]{@{}c@{}}#2\end{tabular}}
\newcommand{\thedate}{\today}

\usepackage{pgfplotstable}
\renewcommand{\bibsection}{}

\begin{document}


\begin{titlepage}
    \begin{flushright}
        \Huge
        \textbf{How to automate result reporting}
\color{black}
\rule{16cm}{2mm} \\
\Large
\color{black}
\thedate \\
\color{blue}
https://github.com/jimb0w/ \\
\color{black}
       \vfill
    \end{flushright}
        \Large


\noindent
Correspondence to: \\
\noindent
Jedidiah Morton \\
\color{blue}
\href{mailto:Jedidiah.Morton@Monash.edu}{Jedidiah.Morton@monash.edu} \\ 
\color{black}
Research Fellow \\
Baker Heart and Diabetes Institute, Melbourne, Australia \\
Monash University, Melbourne, Australia \\

\end{titlepage}

\clearpage
\tableofcontents

\clearpage
\section{Data cleaning}

Document everything.

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
cd /home/jimb0w/Downloads/tempauto/
texdoc stlog close



/***

\end{document}
***/

texdoc close


cd /home/jimb0w/Downloads/tempauto/


! pdflatex auto
! pdflatex auto
! bibtex auto
! pdflatex auto
! bibtex auto
! pdflatex auto

*erase auto.aux
*erase auto.log
*erase auto.out
*erase auto.toc
*erase auto.bbl
*erase auto.blg



! git init .
! git add auto.do auto.pdf
! git commit -m "0"
! git remote remove origin
! git remote add origin https://github.com/jimb0w/automation.git
! git remote set-url origin git@github.com:jimb0w/automation.git
! git push --set-upstream origin master
