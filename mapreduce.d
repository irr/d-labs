import std.stdio;
import std.algorithm;
import core.thread;
import std.parallelism;

struct Student
{
    int number;
    int[] grades;

    double averageGrade() @property
    {
        writefln("Started working on student %s",
                 number);
        Thread.sleep(dur!"seconds"(1));

        immutable average =
            reduce!"a + b"(0.0, grades) / grades.length;

        writefln("Finished working on student %s", number);
        return average;
    }
}

void main()
{
    Student[] students;

    foreach (i; 0 .. 10) {
        /* Two grades for each student */
        students ~= Student(i, [80 + i, 90 + i]);
    }

    auto results = taskPool.amap!"a.averageGrade"(students);

    foreach (result; results) {
        writeln(result);
    }
}
