module testbench.not_a_test;

import bdd.types;

@scenario("This should not be run")
void f() {
    assert(0, "This is not a test func");
}
