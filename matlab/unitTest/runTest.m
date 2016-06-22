suite = matlab.unittest.TestSuite.fromFile('TestCarpet.m');
{suite.Name}'

suite.run;

s1 = suite.selectIf('ParameterName','small');
{s1.Name}'

s1.run;