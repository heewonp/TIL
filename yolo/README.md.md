# window에서 darknet이용하여 yolo custom training

## 1. 비주얼 스튜디오 설치

- Visual studio를 설치 해준다.(https://visualstudio.microsoft.com/ko/vs/older-downloads/)

## 2. NVIDIA CUDA 설치

- NVIDIA CUDA 를 설치 해준다.(https://developer.nvidia.com/cuda-downloads)

  > 윈도우 -> 장치 관리자 -> 본인의 그래픽 카드 정보를 볼 수 있다.
  >
  > https://graydonkey.tistory.com/8 를 참고하여 다운로드 해준다.

## 3. cuDNN 설치

- https://developer.nvidia.com/cudnn 사이트에 들어가 회원가입을 진행한다.

- 자신의 CUDA버전에 맞게 다운로드 해준다.

- 다운받으면 `cuda` 폴더가 생긴다. 폴더안에 `bin,include,lib` 가 있는데, 거기안에 있는 파일들을 설치한`cuda` 폴더에 넣어준다.(cudatoolkit)폴더 경로는 아래와 같다.

  bin : C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.1\bin

  include : C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.1\include

  lib :C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.1\lib 

  여기 안에 각각 cuda폴더와 맞추어 넣어 주면 된다.

## 4. openCV설치

-  https://opencv.org/releases/ 사이트에 들어가서 다운로드 해준다.

## 5. darknet설치 및 파일 설정

- https://github.com/AlexeyAB/darknet/ 사이트에 들어가 clone 혹은 다운로드 해준다.

- darknet\build\darknet\darknet.vcxproj 파일을 메모장 혹은 notepad++ 등으로 열어준다.

  > ![target](https://user-images.githubusercontent.com/59459751/102291600-d06e7700-3f86-11eb-898a-432b3820f975.PNG)
  >
  > CUDA 10.1 targets 라는 부분에 본인에 맞는 CUDA  버전으로 바꾸어 준다.
  >
  > ![props](https://user-images.githubusercontent.com/59459751/102291628-dfedc000-3f86-11eb-8614-babd275a6e42.PNG)
  >
  > CUDA 10.1 props 부분에 본인에 맞는 CUDA 버전으로 바꾸어 준다.

- darknet\build\darknet\darknet.sln 를 비주얼 스튜디오에서 실행을 해준다.

- 프로젝트 -> 속성에 들어간다.

- 구성은 realease로 플랫폼은 x64로 바꾸어준다!

- C/C++일반에 들어간다.

  > ![opencv](https://user-images.githubusercontent.com/59459751/102291566-bcc31080-3f86-11eb-992b-c68e806f7d49.PNG)
  >
  > 본인이 다운 받은 opencv의 include폴더의 경로를 적어줌.
  >
  > 저 사진과 같이 적어 줄것

- ![cuda](https://user-images.githubusercontent.com/59459751/102291651-ebd98200-3f86-11eb-9027-e85fade57011.PNG)

  > CUDA C/C++ -> divice->code ceneration 에 들어가서 본인 GPU에 맞는 값으로 바꾸어 준다.

- ![opencv2](https://user-images.githubusercontent.com/59459751/102291724-1297b880-3f87-11eb-9791-b3080565d034.PNG)

  > 링커 -> 일반에 들어가서 사진과 같이 설정해준다. **본인 경로에 맞게 설정** 해준다.

- darknet.exe가 생성되는 경로에 dll파일들을 복사해서 넣어 준다.

  > darknet-master\darknet-master\build\darknet\x64  폴더에 
  >
  > opencv_world401.dll
  >
  > opencv_ffmpeg401_64.dll
  >
  > cusolver64_본인버전.dll
  >
  > curand64_본인버전.dll
  >
  > cudart64_본인버전.dll
  >
  > cublas64_본인버전.dll
  >
  > 에 맞는 파일들을 넣어서 복사 해준다.

자세한 부분들은 https://studyingcoder.blogspot.com/2019/04/open-source-yolo-v3.html 블로그를 참고하면 좋다.

- 마지막으로 `darknet.sln`를 빌드해주면 `darknet.exe`가 생성이 된다.

## 6. YOLO커스텀을 하기위한 설정들

- https://github.com/AlexeyAB/darknet/blob/0039fd26786ab5f71d5af725fc18b3f521e7acfd/cfg/yolov3.cfg#L8-L9 에 들어가 `.cfg`파일을 만들어 준다.

- 메모장이나 노트패드를 이용해 파일을 수정 해준다.

  - ![KakaoTalk_20201215_225334810](https://user-images.githubusercontent.com/59459751/102292253-24c62680-3f88-11eb-9f3f-124267d68476.png)

    > 학습시킬때는 traning부분을 주석을 풀고 실행, 학습이 끝난 뒤 사용할때는 testing부분주석을 풀어 주면된다.
    >
    > `subdivision `: 학습을 시킬때, **CUDA Error: out of memory** 가 나올 경우가 있다. 그럴 경우에 64를 넘지 말되,  16 배수로 늘려서 하면된다. (예시 :32,48,64... )
    >
    > `batch`: 만약 subdivisions를 64까지 했으나, **CUDA Error: out of memory**  가 나온다면 batch사이즈를 줄여주면된다.마찬가지로 16배수로 줄여준다.
    >
    > `width/height` : 본인이 학습 시키고 싶은 이미지 사이즈를 적어주면 된다. (320, 416, 608) 중에 하나 선택
    >
    > `learning mate`: 0.001/ 본인의 GPU개수
    >
    > `burn_in` : 1000 * 본인의 GPU개수
    >
    > `max_batchs`: 2000 ~ 4000 사이를 선택한 후 본인의 class개수를 곱해줌 (예시 2000 * 본인의 클래스(20)일경우 = 40000)
    >
    > `steps`: 본인의 max_batchs의 80%,90%

  - ![KakaoTalk_20201215_225334810_01](https://user-images.githubusercontent.com/59459751/102293115-c9953380-3f89-11eb-832d-11852371252d.png)

    > `convolutional, yolo`는 3번나오는데 3번다 저 사진을 참고하여 바꾸어 준다.

- build\darknet\x64\data\ 폴더에  `본인이 설정한 폴더 이름.names` 파일을 만들어 준다.

  ![KakaoTalk_20201216_105407321_01](https://user-images.githubusercontent.com/59459751/102294716-4249bf00-3f8d-11eb-8d66-8fb43be294d3.png)

  > 본인이 설정한 class name들을 줄바꿈해서 써준다.

- build\darknet\x64\data\ 폴더에  `본인이 설정한 폴더 이름.data` 파일을 만들어 준다.

  ![KakaoTalk_20201216_105407321](https://user-images.githubusercontent.com/59459751/102294804-64434180-3f8d-11eb-93a6-d31287d7751c.png)

  > 본인에게 맞게 수정해준다. class개수와 train, test파일이 있는 경로 등등...


- yolo .weight파일을 받아준다. 

- images폴더에 사진과 사진이름과 똑같은 .txt파일을 넣어준다.  .txt파일에는 이미지클래스 위치에 대한 좌표와 class  번호가 있다.

  ![image](https://user-images.githubusercontent.com/59459751/102296367-82f70780-3f90-11eb-8d93-9d6c80c72356.png)

- build\darknet\x64\data\ 에 train.txt는 data/`images`/~~.jpg 가쭉 적혀있어야 한다 저 images의 이름과 맞추어서 `.names,.data` 파일의 이름을 맞추어 준다. 만약 images가 아니고 obj라면 data/`obj`/ ~~.jpg가 되고, `obj.names,obj.data`로 되어야 한다.

- darknet.exe파일이 있는 위치까지 이동후, 커맨드창에서 `darknet.exe detector test data/image.data yolo-obj.cfg yolo-obj_8000.weights` 치면 학습이 실행된다.

  > 본인의 경로와 설정한 이름에 맞추어 지정을 해주어야 한다. 자세한건 darknet git readme를 참고하면 좋다. 만약 gpu가 여러개라 다 사용하고 싶다면 뒤에 `-gpus0,1` 써주면 된다. 0: 1개, 1: 2개..
  >
  > ![KakaoTalk_20201216_110519454](https://user-images.githubusercontent.com/59459751/102295473-bd5fa500-3f8e-11eb-8619-dee7359c8067.png)
  >
  > 사진을 참고하면 된다.

**TIP** 만약openCV에서 yolov4를 쓰고싶다면 openCV버전이 4.4이상이어야 한다.