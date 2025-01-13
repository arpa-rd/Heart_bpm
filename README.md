# Heart_bpm
<p>This project takes in ECG data, divides it into time frames (windows) of 8sec, determines beats per minute (bpm) of each window. To determine the beats, cross-correlation is done between the provided ECG signal and a QRS template.<br>
  In this project, two types of data were utilized. <br>
    (i) ECG data with Ground Truth (signal1.mat): This struct consists of two arrays- signal(sig), true bpm(BPM0). At first bpm of each window was determined using the ECG signal and then it was compared with true bpm to find mean and maximum error. <br>
    (ii) ECG data without Ground Truth (test_signal_B1.mat): This contains only one array- ECG signal. Bpm of each window was calculated and plotted.</p>
