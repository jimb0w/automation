
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

Document everything! Say what you're going to do, do it, then comment on it.

For example: I'm going to create a random health dataset with the following variables:
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
gen sex = runiformint(0,1)
gen age = rnormal(60,15)
gen diabetes = runiformint(0,1)
gen smoking = runiformint(0,1)
gen ldl = rnormal(3,0.5)
gen outcome = rnormal(200,30)+diabetes*rnormal(100,20)
export delimited using randomhealthdata.csv, replace
save randomhealthdata, replace
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
The code below produces Figure~\ref{distcheck}.

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
mkdir GPH
hist ldl, frequency ///
xtitle("LDL-C (mmol/L)")
graph save GPH/LDL_hist, replace
hist age, frequency ///
xtitle("Age (years)")
graph save GPH/Age_hist, replace
hist outcome, frequency ///
xtitle("Outcome (units)")
graph save GPH/Outcome_hist, replace
graph combine ///
GPH/LDL_hist.gph ///
GPH/Age_hist.gph ///
GPH/Outcome_hist.gph ///
, cols(1) altshrink xsize(3)
graph export GPH/distcheck.pdf, as(pdf) replace
texdoc stlog close

/***
\color{black}
\clearpage
\thispagestyle{empty}

\begin{figure}[h!]
    \centering
    \caption{Histograms of LDL-C, Age, and outcome.}
    \includegraphics[width=\textwidth]{GPH/distcheck.pdf}
    \label{distcheck}
\end{figure}

\clearpage
It appears that our age and LDL-C variables are normally distirbuted and seem reasonable. 
there is an odd, bimodal distribution in the outcome variable.

In terms of automation, the key thing here was producing my Figures using
code, rather than a graphics program, and automatically exporting them to pdf,
before importing them and displaying them within the document.
Notice also that Figure~\ref{distcheck} hyperlinks to the figure if referenced
properly, so if you update the figure order later, you don't have to re-number
all your figure references in the text.
That means if you change anything in your analysis, add a figure, etc., you don't need
to re-make the figure, just re-run the code and it will re-appear updated in this pdf file.

\clearpage
\section{Analysis}

Before beginning our analysis, we should present a summary table of population characteristics.
We are most interested in diabetes, so we intend to stratify this table by diabetes type.

Here, we are going to collect the results from the Stata output 
and store them in a matrix, before saving that matrix to the Stata
dataset editor and formatting the outputs for presentation in a Table.
It helps to first think about the Table you want to present before
collecting the results. 
The Table~\ref{exampletable} is what we're aiming for.

\begin{table}[h!]
\centering
    \caption{Table we are aiming for.}
    \label{exampletable}
	\begin{tabular}{lrrr}
\hline
& \multicolumn{1}{c}{Overall} & \multicolumn{2}{c}{Diabetes status} \\
Outcome & & No diabetes & Diabetes \\
\hline
Sex & N (\%) & N (\%) & N (\%) \\
Smoking status & N (\%) & N (\%) & N (\%) \\
Age & median (IQR) & median (IQR) & median (IQR) \\
LDL-C & median (IQR) & median (IQR) & median (IQR) \\
Outcome & median (IQR) & median (IQR) & median (IQR) \\
\hline
\end{tabular} \\
Data are presented as N (\%) or median (IQR).
\end{table}

Now that we know what we are aiming for, we need to collect the values. 
Stata's \emph{return list} command is useful here: it tells you what
is stored in Stata's memory, and thus how we can access it.
For example:

\color{Blue4}
***/

texdoc stlog
use randomhealthdata, clear
su(ldl), detail
return list
texdoc stlog close


/***
\color{black}

We can access any one of those statistics and store it for use in our table. 
(Annoyingly ``tabulate'' doesn't store anything useful, so you have to use the \emph{matcell} option.)

So, let's get all the data we need for our table:

\color{Blue4}
***/



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
