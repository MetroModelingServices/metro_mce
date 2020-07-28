set path=C:\ProgramData\Anaconda3\condabin;%path%
call conda activate bca4abmtest
python run_bca.py --config configs_1213 --output output_1213
call conda deactivate
exit
