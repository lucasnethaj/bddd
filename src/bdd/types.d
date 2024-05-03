module bdd.types;

import std.stdio;
import std.range;
import std.array;

import bdd.term;

struct feature {
    string text;
}

struct scenario {
    string text;
}

// void given(string text) {
//     /* writeln("Given ", text); */
//     set_step(Step.given, text);
// }
// 
// void when(string text) {
//     /* writeln("When ", text); */
//     set_step(Step.when, text);
// }
// 
// void then(string text) {
//     /* writeln("Then ", text); */
//     set_step(Step.then, text);
// }
// 
// void set_step(Step step, string text) {
//     current_step = StepContext(step, text);
// }

void given(string text, void delegate() func) {
    run_step(Step.given, text, func);
}

void when(string text, void delegate() func) {
    run_step(Step.when, text, func);
}

void then(string text, void delegate() func) {
    run_step(Step.then, text, func);
}

void run_step(Step step, string text, void delegate() func) {
    current_feature.current_scenario.steps ~= StepContext(step, text);
    if(current_feature.current_scenario.any_failed) {
        return;
    }
    try {
        func();
    }
    catch(Throwable t) {
        /* current_feature.current_scenario.failed = true; */
        /* current_feature.current_scenario.current_step.failed = true; */
        current_feature.current_scenario.current_step.error = t;
        /* writefln("Failed: %s %s", step, text); */
        writeln(t);
    }
}


enum Step {
    given = "Given",
    when = "When",
    then = "Then",
}

static FeatureContext current_feature;

struct FeatureContext {
    string text;
    ScenarioContext[] scenarios;

    ref ScenarioContext current_scenario() {
        return scenarios.back;
    }

    string toString() const {
        Appender!string str;
        str ~= "Feature " ~ text ~ "\n";
        foreach(ref scenario; scenarios) {
            scenario.toString(str);
        }

        return str[];
    }
}

struct ScenarioContext {
    string text;
    StepContext[] steps;
    Throwable error;
    bool failed() const {
        return error !is null;
    }
    bool any_failed() const {
        bool failed_ = failed;
        foreach(step; steps) {
            failed_ |= step.failed;
        }
        return failed_;
    }

    ref StepContext current_step() {
        return steps.back;
    }

    void toString(ref Appender!string str) const {
        if (failed) {
            str ~= RED;
        }
        str ~= "  Scenario " ~ text ~ "\n";
        if (failed) {
            str ~= RESET;
        }

        foreach(ref step; steps) {
            step.toString(str);
            str ~= "\n";
        }
        str ~= RESET;
        if (failed) {
            str ~= "      " ~ error.message ~ "\n";
        }
    }
}

struct StepContext {
    Step step;
    string text;
    Throwable error;
    bool failed() const {
        return error !is null;
    }

    void toString(ref Appender!string str) const {
        if (failed) {
            str ~= RED;
        }
        str ~= "    " ~ step ~ " " ~ text;
        if (failed) {
            str ~= RESET;
            str ~= "\n      " ~ error.message;
            str ~= YELLOW;
        }
    }
}
