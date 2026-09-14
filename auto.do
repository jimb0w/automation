
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
https://github.com/jimb0w/automation \\
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

Say what you're going to do, do it, then comment on it.

I'm going to create a random health dataset with the following variables:
\begin{itemize}
\item Sex (0 $=$ female; 1 $=$ male)
\item Age (in years)
\item Diabetes status (0 $=$ no diabetes; 1 $=$ diabetes)
\item Smoking status (0 $=$ non-smoker; 1 $=$ smoker)
\item LDL-C (in mmol/L)
\item Outcome (in outcome units)
\end{itemize}

As so:

\color{Blue4}
***/

texdoc stlog, cmdlog
cd /home/jimb0w/Downloads/tempauto/
clear
set obs 20000
set seed 1312
gen sex = runiform(0,1)
gen age = rnormal(60,15)
gen diabetes = runiformint(0,1)
gen smoking = runiformint(0,1)
gen ldl = rnormal(3,0.5)
gen outcome = rnormal(200,30)+diabetes*rnormal(100,20)
texdoc stlog close

/***
\color{black}

Now I'm going to check the variables make sense:

\color{Blue4}
***/

texdoc stlog
su(sex), detail
su(diab), detail
su(smoking), detail
su(age), detail
su(ldl), detail
su(outcome), detail
texdoc stlog close

/***
\color{black}

It looks like these variables make sense and there don't appear to be any errors with the data.

But we should check further: let's produce a histogram to check the continuous variables. 

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
hist ldl
hist age
hist outcome
export delimited using randomhealthdata.csv, replace
texdoc stlog close


reg outcome age diabetes smoking ldl
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

erase auto.aux
erase auto.log
erase auto.out
erase auto.toc
erase auto.bbl
erase auto.blg



! git init .
! git add auto.do auto.pdf randomhealthdata.csv
! git commit -m "0"
! git remote remove origin
! git remote add origin https://github.com/jimb0w/automation.git
! git remote set-url origin git@github.com:jimb0w/automation.git
! git push --set-upstream origin master
