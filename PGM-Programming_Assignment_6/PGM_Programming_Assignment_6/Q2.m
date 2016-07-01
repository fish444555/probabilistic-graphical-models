function result = Q2(I,E)
m_I = I;
prod = I.RandomFactors(1);
for i = 2:length(I.RandomFactors)
    prod = FactorProduct(prod,I.RandomFactors(i));
end
prod = ObserveEvidence(prod, E);
m_I.RandomFactors = prod;
result = SimpleCalcExpectedUtility(m_I);
end