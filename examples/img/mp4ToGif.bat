set name=%~n1
rem set OPT=-"vf scale=480:-1"
ffmpeg -i "%name%".mp4  %OPT% "%name%".gif
