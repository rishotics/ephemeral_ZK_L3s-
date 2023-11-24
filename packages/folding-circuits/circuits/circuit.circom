pragma circom 2.0.0;

include "../../../node_modules/circomlib/circuits/comparators.circom";

template Main(nTurns){

    // private_inputs:
    // numbers_chosen_by_A : vec [ ],
    // numbers_guessed_by_B : vec [ ],
    signal input numbers_chosen_by_A[nTurns];
    signal input numbers_guessed_by_B[nTurns];

    // public_inputs:
    signal  input hashA;
    signal  input hashB;
    signal  input winner;

    component checkEqual[nTurns];
    for(var i=0;i<nTurns;i++)
    {
        checkEqual[i] = IsEqual();
        checkEqual[i].in[0] <== numbers_chosen_by_A[i];
        checkEqual[i].in[1] <== numbers_guessed_by_B[i];

    }
    // // log(checkEqual[nTurns-1]);

    signal outs[nTurns+1];
    outs[0] <== checkEqual[0].out;

    for(var i=1;i<nTurns;i++){
        outs[i] <== outs[i-1] + checkEqual[i].out;
    }

    signal twiceSum;
    twiceSum <== 2 * outs[nTurns-1];

    component checkLessThan = LessThan(252);
    checkLessThan.in[0] <== nTurns;
    checkLessThan.in[1] <== twiceSum;

    winner === checkLessThan.out;
}

component main { public [hashA, hashB, winner] } = Main(5);