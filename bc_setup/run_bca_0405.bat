set path=C:\ProgramData\Anaconda3\condabin;%path%
call conda activate bca4abmtest
python run_bca.py --config configs_0405 --output output_0405
call conda deactivate
exit
