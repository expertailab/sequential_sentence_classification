dvc run -n train_allen_seq -d data/ -d train_eval_script.py -p params/params_train.yaml:global,reader,attention,model,trainer -M metrics/metrics_eval_test.json --outputs-persist outputs/ python train_eval_script.py