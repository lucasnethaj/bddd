module bdd.runner;

import core.exception;

import std.traits;
import std.stdio;

import bdd.types;

import testbench.all_modules;

void main() {

    static foreach(test_module; test_modules) {
        current_feature = FeatureContext((getUDAs!(test_module, feature))[0].text);
        static foreach(func; getSymbolsByUDA!(test_module, scenario)) {
            current_feature.scenarios ~= ScenarioContext((getUDAs!(func, scenario))[0].text);
            try {
                func();
            }
            catch(Throwable e) {
                current_feature.current_scenario.error = e;
                /* stderr.writeln("Scenario failed: ", current_feature.current_scenario); */
                /* stderr.writeln(e); */
            }
        }
        writeln(current_feature);
    }

}
