clear all;
close all;
numTaps = 48;
stepSize = 0.0005; 
numIter = 50000;
noise = audioread('whiteNoise.wav');

##random coefficients for feedback path simulation
wFb_sim = [-0.0130619787417241;0.0975274606756307;-0.760707782179873;-0.648081392744718;0.466048586875652;-0.899564872342897;
-0.534943175564215;-0.450410268194025;0.631360266834234;0.913419007542353;-0.288698085944698;0.300959259522251;
0.495169387910575;0.315869337063673;-0.885961696432526;-0.731185939714855;0.298633572593211;0.395909838984813;
-0.912884239174294;-0.0306302005515233;0.933940977862997;-0.0833222564701948;-0.212022255049134;-0.567880018087895;
-0.937348349900492;-0.957268621117205;-0.535722579259675;0.724084798693572;-0.513313391863763;0.902050603300468;
0.0412877193227206;0.484906275029576;-0.894545748636341;-0.731022468539235;-0.629479514501000;-0.256482053655979;
0.532493938467192;-0.922187322345040;0.894782131681160;0.303341923337543;-0.305968957361622;-0.943543492753397;
0.905314917381150;-0.330996741280741;0.410514358791861;0.623763915785284;-0.559902867402985;-0.555751071865022];

##random coefficients for primary path simulation
wPp_sim = [-0.625126992583921;-0.304642945733449;0.417626058326433;0.121025321206513;0.0880266051692740;-0.982160969642271;
0.135826991774280;0.295894736232541;-0.103459210456720;-0.997568336413468;-0.00251423406967111;0.834297230859256;
0.685481188985162;0.503737419347963;0.298568281930836;-0.869092401840699;0.476556938814341;-0.415080668817059;
0.0995202036887553;-0.0424335098481639;0.158952938010430;0.854972960446818;0.902426688833245;-0.743243122643917;
-0.322492108519032;-0.739825134434165;0.839116524650747;-0.417744384245003;0.567572911499774;-0.185762174866201;
-0.286795123840357;-0.389436534534701;-0.653634125073076;-0.851231563247437;-0.766537695668935;0.599097156044471;
0.313110522496423;0.259105943508262;-0.524907845402232;-0.855788234307356;-0.485477093706225;0.369547564908214;
0.0703676880786666;0.227126746685788;0.795382912800763;0.914874829293304;0.889706914058301;0.0838165914288378];

##random coefficients for secondary path simulation
wSp_sim = [0.472905068457980;-0.0207952311853141;0.773645264214913;0.0612990633287838;0.0545054402633280;0.264969696011226;
-0.652440270692192;-0.598195696247264;-0.0414571961594561;0.441810327909271;0.338904337680898;0.499140649285646;
-0.651605652142787;-0.0305304789744874;-0.180793358084645;0.939872621092447;0.275946760729188;-0.930026716046422;
0.739433670168079;-0.00744333548363585;0.128439009070355;0.355245251760885;-0.0367295821674347;-0.921610388124199;
0.593409509147421;0.605914266380097;-0.0634348285194017;0.683384511110494;-0.676464765801300;0.717782681374582;
-0.610870953406309;-0.0988107620779912;0.723501768018158;0.712043930347406;-0.655410881558301;-0.424628694770462;
0.982999886767437;0.514395279991580;0.116866074506139;0.658874915074193;-0.0396835259780102;0.146546344345881;
0.219542512838598;0.779760105959012;-0.827254924255254;0.431476547186726;0.955623476738027;0.423353903001909];

##simulate secondary, feedback and primary path effects
dSp = filter(wSp_sim, 1, noise(1 : numIter));
dFb = filter(wFb_sim, 1, noise(1 : numIter));
dPp = filter(wPp_sim, 1, noise(1 : numIter));

##Secondary path identification
[wSp, eSp, mseSp] = lmsFunct(noise, numTaps, numIter, stepSize ,dSp);

figure('name', 'Secondary path identification reference signal');
plot(dSp, 'b');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Secondary path identification reference signal d(n)')
ylabel('Amplitude');
xlabel('Discrete time');

figure('name', 'Secondary path identification error signal');
plot(eSp, 'r');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Secondary path identification error signal e(n)')
ylabel('Amplitude');
xlabel('Discrete time');

figure('name', 'Secondary path identification MSE');
plot(mseSp, 'g');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Secondary path identification MSE')
ylabel('Amplitude');
xlabel('Discrete time');

##Feedback path identification
[wFb, eFb, mseFb] = lmsFunct(noise, numTaps, numIter, stepSize ,dFb);

figure('name', 'Feedback path identification reference signal');
plot(dSp, 'b');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Feedback path identification reference signal d(n)')
ylabel('Amplitude');
xlabel('Discrete time');

figure('name', 'Feedback path identification error signal');
plot(eSp, 'r');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Feedback path identification error signal e(n)')
ylabel('Amplitude');
xlabel('Discrete time');

figure('name', 'Feedback path identification MSE');
plot(mseSp, 'g');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Feedback path identification MSE')
ylabel('Amplitude');
xlabel('Discrete time');


##Feedback Filtered x algorithm active noise cancellation simulation
[dPp, ePp, wPp, msePp] = feedbackFxlmsFunct(noise, numTaps, numIter, stepSize, wFb, wSp, wPp_sim, wFb_sim, wSp_sim);
    
figure('name', 'Primary path identification reference signal');
plot(dPp, 'b');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Primary path identification reference signal d(n)')
ylabel('Amplitude');
xlabel('Discrete time');

figure('name', 'Primary path identification error signal');
plot(ePp, 'r');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Primary path identification error signal e(n)')
ylabel('Amplitude');
xlabel('Discrete time');

figure('name', 'Primary path identification MSE');
plot(msePp, 'g');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Primary path identification MSE')
ylabel('Amplitude');
xlabel('Discrete time');
