local stringToBool(s) =
  if s == "true" then true
  else if s == "false" then false
  else error "invalid boolean: " + std.manifestJson(s);

local boolToInt(s) =
  if s == true then 1
  else if s == false then 0
  else error "invalid boolean: " + std.manifestJson(s);

{
  "random_seed": std.parseInt(std.extVar("SEED")),
  "pytorch_seed": std.parseInt(std.extVar("PYTORCH_SEED")),
  "numpy_seed": std.parseInt(std.extVar("NUMPY_SEED")),
  "dataset_reader" : {
        "type": "SeqClassificationReader",
        "tokenizer": {
            "type": "pretrained_transformer",
            "model_name": std.extVar("BERT_MODEL"),
            "tokenizer_kwargs": {"truncation_strategy" : 'do_not_truncate'},
        },
        "token_indexers": {
            "bert": {
                "type": "pretrained_transformer",
                "model_name": std.extVar("BERT_MODEL"),
                "tokenizer_kwargs": {"truncation_strategy" : 'do_not_truncate'},
            }
        },
        "sent_max_len": 80,
        "max_sent_per_example": 10,
        "use_sep": stringToBool(std.extVar("USE_SEP")),
        "sci_sum": stringToBool(std.extVar("SCI_SUM")),
        "use_abstract_scores": boolToInt(stringToBool(std.extVar("USE_ABSTRACT_SCORES"))),
        "sci_sum_fake_scores": boolToInt(stringToBool(std.extVar("SCI_SUM_FAKE_SCORES"))),
    },
  "train_data_path": std.extVar("TRAIN_PATH"),
  "validation_data_path": std.extVar("DEV_PATH"),
  "test_data_path": std.extVar("TEST_PATH"),
  "evaluate_on_test": true,
  "model": {
    "type": "SeqClassificationModel",
    "text_field_embedder": {
        "token_embedders": {
            "bert": {
              "type": "pretrained_transformer",
              "model_name": std.extVar("BERT_MODEL"),
              "train_parameters": 1,
              "last_layer_only": 0,

        }
        }
    },
    "use_sep": stringToBool(std.extVar("USE_SEP")),
    "intersentence_token":std.extVar("TOKEN"),
    "model_type":std.extVar("MODEL_TYPE"),
    "with_crf": stringToBool(std.extVar("WITH_CRF")),
    "bert_dropout": 0.1,
    "sci_sum": stringToBool(std.extVar("SCI_SUM")),
    "additional_feature_size": boolToInt(stringToBool(std.extVar("USE_ABSTRACT_SCORES"))),
    "self_attn": {
      "type": "pytorch_transformer",
      "input_dim": 768,
      "feedforward_hidden_dim": 100,
      "num_layers": 2,
      "num_attention_heads": 2,
    },
  },
  "data_loader": {
        "batch_size": std.parseInt(std.extVar("BATCH_SIZE")),
        "shuffle": true
  },
  "trainer": {
    "num_epochs": std.parseInt(std.extVar("NUM_EPOCHS")),
    "grad_clipping": 1.0,
    "patience": 5,
    "validation_metric": '+acc',
    "cuda_device": std.parseInt(std.extVar("cuda_device")),
    "num_gradient_accumulation_steps": 50, 
    "optimizer": {
      "type": "huggingface_adamw",
      "lr": std.parseJson(std.extVar("LR")),
      "weight_decay": 0.01,
    },
    "learning_rate_scheduler": {
      "type": "slanted_triangular",
      "num_epochs": std.parseInt(std.extVar("NUM_EPOCHS")),
      "cut_frac": 0.1,
    },
  }
}
