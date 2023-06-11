# Digital-communication-system
This project aims to implement a line coding system, as well as a binary phase shift-keying (BPSK) transmitter and receiver, and provide sufficient visualization for the signals, their spectra, and the effects of noise on them, all done using Octave.

## How to install and run this project:

1. Git clone the repository or download the zip file.
    ```
    git clone https://github.com/MariamH78/Digital-communication-system.git
    ```
2. Run `main.m` through `Octave`, or write your own main!

__Note 1:__ This assumes that you have `Octave` installed on your machine.\
__Note 2:__ As of right now, the code will not run on `Matlab` since the code files are not compatible, they will need a few small changes first.

## Usage and expected output:

There are two provided classes for the package, `transmitter` class, and `receiver` class. The classes' functions, use cases and implementation details are all provided in [project_report.pdf](https://github.com/MariamH78/Digital-communication-system/blob/main/project_report.pdf), and a [main.m](https://github.com/MariamH78/Digital-communication-system/blob/main/main.m) is provided as an example as well.
  
### As a quick summary:
- The `transmitter` class provides methods to:
  1. Generate bit stream.
  2. Encode bit stream using one of __7__ styles: `Unipolar non-/return to zero`, `Polar non-/return to zero`, `Bipolar non-/return to zero`, or `Manchester`.
  3. Use BPSK to modulate the signal.
  4. Plot any of the generated streams and signals above.
- The `receiver` class provides methods to:
  1. Receive stream from transmitter object.
  2. Decode the encoded stream.
  3. Demodulate the BPSK stream.
  4. Add noise to the received signal and test decision making from step ii again.
  5. Plot any of the generated streams and signals above.
- The few other files are helper functions that calculate `BER (bit error rate)` and plot it against the sigma of the noise.

### Below are a few snapshots of the expected outputs:
<div align="center">
    
| | |
|:-------------------------:|:-------------------------:|
|<img width="286" alt="sigma vs BER for all line coding styles" src="https://github.com/MariamH78/Digital-communication-system/assets/99722575/2baba662-576e-4b4f-8370-696983ed6651">  |<img width="286" alt="bipolar return to zero sigma vs BER plot" src="https://github.com/MariamH78/Digital-communication-system/assets/99722575/8702cd83-a76d-46ca-bd0c-4bed3da7e691">|
       
| |
|:-------------------------:|
|<img width="600" alt="bpsk transmitter stream" src="https://github.com/MariamH78/Digital-communication-system/assets/99722575/89333334-b72d-4778-9abf-f4bde19d17f1">| 
|<img width="600" alt="transmitted bipolar return to zero stream" src="https://github.com/MariamH78/Digital-communication-system/assets/99722575/c012379f-12cf-4267-8692-1376ad4367c2">|
|<img width="600" alt="bipolar return to zero eyediagram and power spectrum" src="https://github.com/MariamH78/Digital-communication-system/assets/99722575/a8fa51d6-2936-4995-a56e-3150e192367d">|
|<img width="600" alt="noisy received stream with sigma of 0.5" src="https://github.com/MariamH78/Digital-communication-system/assets/99722575/1a9d5d37-0b2d-4a25-83ec-b28048446520">|
  
</div>
  
## TODO:
1. For easier readability, each class can be supported by a few helper classes instead of one, big, very hard to read file for each class.
2. Compatibility issues with Matlab can be addressed.
