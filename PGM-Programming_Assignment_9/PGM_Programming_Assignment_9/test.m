function test
testc = 2;
load PA9SampleCases


switch testc
    case 1 % EM_cluster
        [P loglikelihood ClassProb] = EM_cluster(exampleINPUT.t1a1, exampleINPUT.t1a2, exampleINPUT.t1a3, exampleINPUT.t1a4);        
        result = isEqualTol(P, exampleOUTPUT.t1a1, 'Output.t1a1', 1e-3) && ...  
            isEqualTol(loglikelihood, exampleOUTPUT.t1a2, 'Output.t1a2', 1e-2) && ...  
            isEqualTol(ClassProb, exampleOUTPUT.t1a3, 'Output.t1a3', 1e-4) ;
        assert(result==1);
        disp('Success!');
    case 2 % EM_HMM
        [P loglikelihood ClassProb PairProb] = EM_HMM(exampleINPUT.t2a1, exampleINPUT.t2a2, exampleINPUT.t2a3, exampleINPUT.t2a4, exampleINPUT.t2a5, exampleINPUT.t2a6);
        result = isEqualTol(P, exampleOUTPUT.t2a1, 'Output.t2a1b', 1e-3) && ...  
            isEqualTol(ClassProb, exampleOUTPUT.t2a3, 'Output.t1a2', 1e-5) && ...  
            isEqualTol(PairProb, exampleOUTPUT.t2a4, 'Output.t1a3', 1e-5) && ...
            isEqualTol(loglikelihood, exampleOUTPUT.t2a2, 'Output.t1a3', 1e-3);
        assert(result==1);
        disp('Success!');
    case 3 % EM_HMM - first iteration
        [P loglikelihood ClassProb PairProb] = EM_HMM(exampleINPUT.t2a1, exampleINPUT.t2a2, exampleINPUT.t2a3, exampleINPUT.t2a4, exampleINPUT.t2a5, 1);
        result = isEqualTol(P, exampleOUTPUT.t2a1b, 'Output.t2a1b', 1e-3) && ...  
            isEqualTol(ClassProb, exampleOUTPUT.t2a3b, 'Output.t1a2', 1e-5) && ...  
            isEqualTol(PairProb, exampleOUTPUT.t2a4b, 'Output.t1a3', 1e-5) && ...
            isEqualTol(loglikelihood, exampleOUTPUT.t2a2b, 'Output.t1a3', 1e-3);
        assert(result==1);
        disp('Success!');
    case 4 % RecognizeActions
        [acc pl] = RecognizeActions(exampleINPUT.t3a1, exampleINPUT.t3a2, exampleINPUT.t3a3, exampleINPUT.t3a4);
        result = isEqualTol(acc, exampleOUTPUT.t3a1, 'Output.t2a1b', 1e-6) && ...  
            isEqualTol(pl, exampleOUTPUT.t3a2, 'Output.t1a2', 1e-6);
        assert(result==1);
        disp('Success!');
end
end