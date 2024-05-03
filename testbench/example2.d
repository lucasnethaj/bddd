@feature("This another test test")
module testbench.example2;

import bdd.types;

@scenario("I do some great stuff") _ = {
    given("I have a great friend", {
            //
    });

    when("I that friend does something stoopid", {
            ///
    });

    assert(0, "bad");

    then("He will go to jail", {
            /// 
    });
};

@scenario("nein") __ = {
    given("a", {});
};
