@feature("test the bdd")
module bdd.test;

import bdd.types;

@scenario("We run a test scenario")
void f() {

    given("We have a test", {
            //
    });

    when("i run the test", {
        assert(0, "oh nooess!");
    });
    then("it should succeed", {
        //
    });
}
