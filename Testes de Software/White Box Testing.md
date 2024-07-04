White-Box Testing
White-box testing is concerned with the degree to which test cases exer-
cise or cover the logic (source code) of the program. As we saw in Chap-
ter 2, the ultimate white-box test is the execution of every path in the
program; but complete path testing is not a realistic goal for a program
with loops.
42 The Art of Software Testing
Logic Coverage Testing
If you back completely away from path testing, it may seem that a worthy
goal would be to execute every statement in the program at least once.
Unfortunately, this is a weak criterion for a reasonable white-box test. This
concept is illustrated in Figure 4.1. Assume that this figure represents a
small program to be tested. The equivalent Java code snippet follows:
public void foo(int A,int B,int X) {
if(A>1 && B¼¼0) {
X¼X/A;
}
if(A¼¼2 jj X>1) {
X¼Xþ1;
}
}
FIGURE 4.1 A Small Program to Be Tested.
Test-Case Design 43
You could execute every statement by writing a single test case that
traverses path ace. That is, by setting A¼2, B¼0, and X¼3 at point a, every
statement would be executed once (actually, X could be assigned any inte-
ger value >1).
Unfortunately, this criterion is a rather poor one. For instance, perhaps
the first decision should be an or rather than an and. If so, this error would
go undetected. Perhaps the second decision should have stated X>0; this
error would not be detected. Also, there is a path through the program in
which X goes unchanged (the path abd). If this were an error, it would go
undetected. In other words, the statement coverage criterion is so weak
that it generally is useless.
A stronger logic coverage criterion is known as decision coverage or
branch coverage. This criterion states that you must write enough test cases
that each decision has a true and a false outcome at least once. In other
words, each branch direction must be traversed at least once. Examples of
branch or decision statements are switch-case, do-while, and if-else
statements. Multipath GOTO statements qualify in some programming
languages such as Fortran.
Decision coverage usually can satisfy statement coverage. Since every
statement is on some subpath emanating either from a branch statement
or from the entry point of the program, every statement must be executed
if every branch direction is executed. There are, however, at least three
exceptions:
 Programs with no decisions.
 Programs or subroutines/methods with multiple entry points. A given
statement might be executed only if the program is entered at a
particular entry point.
 Statements within ON-units. Traversing every branch direction will
not necessarily cause all ON-units to be executed.
Since we have deemed statement coverage to be a necessary condition,
decision coverage, a seemingly better criterion, should be defined to
include statement coverage. Hence, decision coverage requires that each
decision have a true and a false outcome, and that each statement be exe-
cuted at least once. An alternative and easier way of expressing it is that
each decision has a true and a false outcome, and that each point of entry
(including ON-units) be invoked at least once.
44 The Art of Software Testing
This discussion considers only two-way decisions or branches and has to
be modified for programs that contain multipath decisions. Examples are
Java programs containing switch-case statements, Fortran programs con-
taining arithmetic (three-way) IF statements or computed or arithmetic
GOTO statements, and COBOL programs containing altered GOTO statements
or GO-TO-DEPENDING-ON statements. For such programs, the criterion is exer-
cising each possible outcome of all decisions at least once and invoking each
point of entry to the program or subroutine at least once.
In Figure 4.1, decision coverage can be met by two test cases covering
paths ace and abd or, alternatively, acd and abe. If we choose the latter
alternative, the two test-case inputs are A¼3, B¼0, X¼3 and A¼2, B¼1,
and X¼1.
Decision coverage is a stronger criterion than statement coverage, but it
still is rather weak. For instance, there is only a 50 percent chance that
we would explore the path where x is not changed (i.e., only if we chose
the former alternative). If the second decision were in error (if it should
have said X<1 instead of X>1), the mistake would not be detected by the
two test cases in the previous example.
A criterion that is sometimes stronger than decision coverage is condi-
tion coverage. In this case, you write enough test cases to ensure that each
condition in a decision takes on all possible outcomes at least once. But, as
with decision coverage, this does not always lead to the execution of each
statement, so an addition to the criterion is that each point of entry to the
program or subroutine, as well as ON-units, be invoked at least once. For
instance, the branching statement:
DO K¼0 to 50 WHILE (JþK<QUEST)
contains two conditions: Is K less than or equal to 50, and is JþK less than
QUEST? Hence, test cases would be required for the situations K<¼50, K>50
(to reach the last iteration of the loop), JþK<QUEST, and JþK>¼QUEST.
Figure 4.1 has four conditions: A>1, B¼0, A¼2, and X>1. Hence, enough
test cases are needed to force the situations where A>1, A<¼1, B¼0, and
B<>0 are present at point a and where A¼2, A<>2, X>1, and X<¼1 are
present at point b. A sufficient number of test cases satisfying the criterion,
and the paths traversed by each, are:
A¼2, B¼0, X¼4 ace
A¼1, B¼1, X¼1 adb
Test-Case Design 45
Note that although the same number of test cases was generated for this
example, condition coverage usually is superior to decision coverage in
that it may (but does not always) cause every individual condition in a
decision to be executed with both outcomes, whereas decision coverage
does not. For instance, in the same branching statement
DO K¼0 to 50 WHILE (JþK<QUEST)
is a two-way branch (execute the loop body or skip it). If you are using
decision testing, the criterion can be satisfied by letting the loop run from
K¼0 to 51, without ever exploring the circumstance where the WHILE clause
becomes false. With the condition criterion, however, a test case would be
needed to generate a false outcome for the conditions JþK<QUEST.
Although the condition coverage criterion appears, at first glance, to
satisfy the decision coverage criterion, it does not always do so. If the deci-
sion IF(A & B) is being tested, the condition coverage criterion would let
you write two test cases—A is true, B is false, and A is false, B is true—but
this would not cause the THEN clause of the IF to execute. The condition
coverage tests for the earlier example covered all decision outcomes, but
this was only by chance. For instance, two alternative test cases
A¼1, B¼0, X¼3
A¼2, B¼1, X¼1
cover all condition outcomes but only two of the four decision outcomes
(both of them cover path abe and, hence, do not exercise the true outcome
of the first decision and the false outcome of the second decision).
The obvious way out of this dilemma is a criterion called decision/
condition coverage. It requires sufficient test cases such that each condition
in a decision takes on all possible outcomes at least once, each decision
takes on all possible outcomes at least once, and each point of entry is
invoked at least once.
A weakness with decision/condition coverage is that although it may ap-
pear to exercise all outcomes of all conditions, it frequently does not, be-
cause certain conditions mask other conditions. To see this, examine
Figure 4.2. The flowchart in this figure is the way a compiler would gener-
ate machine code for the program in Figure 4.1. The multicondition deci-
sions in the source program have been broken into individual decisions
and branches because most machines do not have a single instruction that
makes multicondition decisions. A more thorough test coverage, then,
46 The Art of Software Testing
appears to be the exercising of all possible outcomes of each primitive de-
cision. The two previous decision coverage test cases do not accomplish
this; they fail to exercise the false outcome of decision H and the true out-
come of decision K.
The reason, as shown in Figure 4.2, is that results of conditions in the
and and the or expressions can mask or block the evaluation of other con-
ditions. For instance, if an and condition is false, none of the subsequent
conditions in the expression need be evaluated. Likewise, if an or condi-
tion is true, none of the subsequent conditions need be evaluated. Hence,
errors in logical expressions are not necessarily revealed by the condition
coverage and decision/condition coverage criteria.
A criterion that covers this problem, and then some, is multiple-condition
coverage. This criterion requires that you write sufficient test cases such that
all possible combinations of condition outcomes in each decision, and all
FIGURE 4.2 Machine Code for the Program in Figure 4.1.
Test-Case Design 47
points of entry, are invoked at least once. For instance, consider the follow-
ing sequence of pseudo-code.
NOTFOUND¼TRUE;
DO I¼1 to TABSIZE WHILE (NOTFOUND); /*SEARCH TABLE*/
.. . searching logic.. . ;
END
The four situations to be tested are:
1. I<¼TABSIZE and NOTFOUND is true.
2. I<¼TABSIZE and NOTFOUND is false (finding the entry before
hitting the end of the table).
3. I>TABSIZE and NOTFOUND is true (hitting the end of the table without
finding the entry).
4. I>TABSIZE and NOTFOUND is false (the entry is the last one in the
table).
It should be easy to see that a set of test cases satisfying the multiple-
condition criterion also satisfies the decision coverage, condition coverage,
and decision/condition coverage criteria.
Returning to Figure 4.1, test cases must cover eight combinations:
1. A>1, B¼0 5. A¼2, X>1
2. A>1, B<>0 6. A¼2, X<¼1
3. A<¼1, B¼0 7. A<>2, X>1
4. A<¼1, B<>0 8. A<>2, X<¼1
Note Recall from the Java code snippet presented earlier that test cases
5 through 8 express values at the point of the second if statement. Since X
may be altered above this if statement, the values needed at this if state-
ment must be backed up through the logic to find the corresponding input
values.
These combinations to be tested do not necessarily imply that eight test
cases are needed. In fact, they can be covered by four test cases. The test-
case input values, and the combinations they cover, are as follows:
A¼2, B¼0, X¼4 Covers 1, 5
A¼2, B¼1, X¼1 Covers 2, 6
48 The Art of Software Testing
A¼1, B¼0, X¼2 Covers 3, 7
A¼1, B¼1, X¼1 Covers 4, 8
The fact that there are four test cases and four distinct paths in Figure 4.1
is just coincidence. In fact, these four test cases do not cover every path; they
miss the path acd. For instance, you would need eight test cases for the
following decision:
if(x¼¼y && length(z)¼¼0 && FLAG) {
j¼1;
else
i¼1;
}
although it contains only two paths. In the case of loops, the number of
test cases required by the multiple-condition criterion is normally much
less than the number of paths.
In summary, for programs containing only one condition per decision,
a minimum test criterion is a sufficient number of test cases to: (1) invoke
all outcomes of each decision at least once, and (2) invoke each point of
entry (such as entry point or ON-unit) at least once, to ensure that all state-
ments are executed at least once. For programs containing decisions hav-
ing multiple conditions, the minimum criterion is a sufficient number of
test cases to invoke all possible combinations of condition outcomes
in each decision, and all points of entry to the program, at least once.
(The word ‘‘possible’’ is inserted because some combinations may be found
to be impossible to create.