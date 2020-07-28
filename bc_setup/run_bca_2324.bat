set path=C:\ProgramData\Anaconda3\condabin;%path%
call conda activate bca4abmtest
python run_bca.py --config configs_2324 --output output_2324
call conda deactivate
exit
