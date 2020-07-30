set path=C:\ProgramData\Anaconda3\condabin;%path%
call conda activate bca4abmtest
python combine_all_periods.py
call conda deactivate
exit
