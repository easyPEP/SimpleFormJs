if (window.JoB === void 0) {
  window.JoB = {};
}

if (JoB.SimpleForm === void 0) {
  window.JoB.SimpleForm = {};
}

JoB.SimpleForm.Base = (function() {
  var INPUT_MAPPING;

  INPUT_MAPPING = {
    boolean: 'checkBoxTag',
    checkboxes: 'checkBoxTag',
    datetime: 'datetimeFieldTag',
    date: 'dateFieldTag',
    decimal: 'input',
    email: 'emailFieldTag',
    file: 'fileFieldTag',
    float: 'input',
    hidden: 'hiddenFieldTag',
    integer: 'input',
    select: 'selectTag',
    string: 'textFieldTag',
    tel: 'telephoneFieldTag',
    password: 'passwordFieldTag',
    radiobuttons: 'radioButtonTag',
    range: 'rangeFieldTag',
    search: 'searchFieldTag',
    text: 'textAreaTag',
    textarea: 'textAreaTag',
    time: 'timeFieldTag',
    url: 'urlFieldTag'
  };

  function Base(argument) {
    this.optionsHelper = new JoB.Form.OptionsHelper();
    this.tagHelper = new JoB.Form.TagHelper();
  }

  Base.prototype._ressoureDefinition = function() {
    if (_.isString(this.base.ressource)) {
      this.base.ressourceName = this.base.ressource;
      return this.base.ressource = false;
    } else if (_.isObject(this.base.ressource)) {
      if (this.base.ressource.modelName != null) {
        this.base.ressourceName = this.base.ressource.modelName;
      } else if (this.base.ressource.className != null) {
        this.base.ressourceName = this.base.ressource.className;
      } else {
        console.log("We could not guess ressourceName, please add modelName or className to the ressource option");
      }
      if (_.isFunction(this.base.ressource.toJSON)) {
        return this.base.ressource = this.base.ressource.toJSON();
      } else {
        return this.base.ressource = this.base.ressource;
      }
    }
  };

  Base.prototype._value = function() {
    var returnString;
    returnString = "";
    if (this.options.value === false) {
      returnString = '';
    } else if (_.isString(this.options.value) && _.isEmpty(this.options.value) === false) {
      returnString = this.options.value;
    } else if (this.base.ressource && _.isString(this.base.ressource[this.base.fieldName])) {
      returnString = this.base.ressource[this.base.fieldName];
    }
    return returnString;
  };

  Base.prototype._placeholder = function() {
    var returnString, translatedPlaceholder;
    returnString = '';
    if (this.options.placeholder === false) {
      returnString = '';
    } else if (_.isString(this.options.placeholder) && _.isEmpty(this.options.placeholder) === false) {
      returnString = this.options.placeholder;
    } else {
      translatedPlaceholder = this.translationHelper.placeholder();
      if (translatedPlaceholder != null) {
        returnString = translatedPlaceholder;
      } else {
        returnString = '';
      }
    }
    return returnString;
  };

  Base.prototype._inputType = function() {
    var type;
    type = '';
    if ((this.options.collection != null) && this.options.as === 'string') {
      type = INPUT_MAPPING['select'];
    } else if (_.isString(this.options.as) && _.isString(INPUT_MAPPING["" + this.options.as])) {
      type = INPUT_MAPPING["" + this.options.as];
    } else {
      type = INPUT_MAPPING['string'];
    }
    return type;
  };

  Base.prototype._selectedOptionTag = function() {
    var selected;
    selected = void 0;
    if (this.base.ressource && this.options.collection) {
      selected = _.find(this.options.collection, (function(_this) {
        return function(el) {
          return el[0] === _this.base.ressource[_this.base.fieldName];
        };
      })(this));
    }
    return selected;
  };

  Base.prototype._collection = function() {
    var collection;
    collection = this.options.collection;
    if (this.options.includeBlank || _.isEmpty(this.options.includeBlank) === false) {
      if (_.isString(this.options.includeBlank)) {
        collection.unshift(["", this.options.includeBlank]);
      } else {
        collection.unshift(["", ""]);
      }
    }
    return collection;
  };

  Base.prototype._optionTags = function() {
    return this.optionsHelper.optionsForSelect(this._collection(), this._selectedOptionTag());
  };

  Base.prototype._radioOrCheckTags = function(inputType) {
    var els, ressource;
    els = [];
    ressource = this.base.ressource;
    _.each(this.options.collection, (function(_this) {
      return function(option) {
        var checked, inputOptions, inputTag, withWrapper;
        checked = ressource && ressource[_this.base.fieldName] === option[0] ? true : false;
        inputOptions = _.clone(_this.inputOptions);
        inputOptions.value = option[0];
        if (inputType === INPUT_MAPPING['radiobuttons']) {
          inputTag = _this.tagHelper.radioButtonTag(_this.base.ressourceName, _this.base.fieldName, checked, inputOptions);
          withWrapper = _this.wrapperHelper.radiobutton(inputTag, option[1]);
        } else {
          inputTag = _this.tagHelper.checkBoxTag(_this.base.ressourceName, _this.base.fieldName, checked, inputOptions);
          withWrapper = _this.wrapperHelper.checkbox(inputTag, option[1]);
        }
        return els.push(withWrapper);
      };
    })(this));
    return els;
  };

  Base.prototype.inputWithWrapper = function() {
    var checked, content, inputHtml, inputType, inputWithWrapper, label;
    inputType = this._inputType();
    inputWithWrapper = '';
    if (inputType === INPUT_MAPPING['select']) {
      this.inputOptions['class'] += " form-control";
      inputHtml = this.tagHelper.selectTag(this.base.ressourceName, this.base.fieldName, this._optionTags(), this.inputOptions);
      inputWithWrapper = this.wrapperHelper["default"](inputHtml);
    } else if (this.options.as === 'boolean') {
      checked = this.base.ressource && this.base.ressource[this.base.fieldName] === 1 ? true : false;
      this.inputOptions.value = 1;
      inputHtml = this.tagHelper.checkBoxTag(this.base.ressourceName, this.base.fieldName, checked, this.inputOptions);
      label = this.wrapperHelper._label();
      inputWithWrapper = this.wrapperHelper.checkbox(inputHtml, label);
    } else if (inputType === INPUT_MAPPING['checkboxes'] || inputType === INPUT_MAPPING['radiobuttons']) {
      inputWithWrapper = this._radioOrCheckTags(inputType).join("");
    } else if (inputType === INPUT_MAPPING['file']) {
      inputHtml = this.tagHelper[inputType](this.base.ressourceName, this.base.fieldName, this.inputOptions);
      inputWithWrapper = this.wrapperHelper["default"](inputHtml);
    } else if (inputType === INPUT_MAPPING['text'] || inputType === INPUT_MAPPING['textarea']) {
      content = this.inputOptions.value;
      delete this.inputOptions.value;
      this.inputOptions['class'] += " form-control";
      inputHtml = this.tagHelper.textAreaTag(this.base.ressourceName, this.base.fieldName, content, this.inputOptions);
      inputWithWrapper = this.wrapperHelper["default"](inputHtml);
    } else {
      if (inputType === INPUT_MAPPING['range']) {
        this.inputOptions['class'] += "";
      } else if (inputType === INPUT_MAPPING['hidden']) {
        this.options.label = false;
      } else {
        this.inputOptions['class'] += " form-control";
      }
      inputHtml = this.tagHelper["" + (this._inputType())](this.base.ressourceName, this.base.fieldName, this.inputOptions);
      inputWithWrapper = this.wrapperHelper["default"](inputHtml);
    }
    return inputWithWrapper;
  };

  Base.prototype.input = function(ressource, fieldName, options, inputOptions, labelOptions, wrapperOptions) {
    if (options == null) {
      options = {};
    }
    if (inputOptions == null) {
      inputOptions = {};
    }
    if (labelOptions == null) {
      labelOptions = {};
    }
    if (wrapperOptions == null) {
      wrapperOptions = {};
    }
    this.base = {
      fieldName: fieldName,
      ressource: ressource
    };
    this._ressoureDefinition();
    this.translationHelper = new JoB.SimpleForm.TranslationHelper(this.base);
    this.options = _.defaults(options, {
      as: 'string',
      type: 'text',
      label: true,
      value: true,
      required: false,
      addonText: false,
      addonPosition: 'right',
      includeBlank: true
    });
    this.inputOptions = _.defaults(inputOptions, {
      "class": '',
      value: this._value(),
      placeholder: this._placeholder()
    });
    this.labelOptions = _.defaults(labelOptions, {});
    this.wrapperOptions = _.defaults(wrapperOptions, {
      "class": 'form-group'
    });
    this.wrapperHelper = new JoB.SimpleForm.WrapperHelper(this.base, this.options, this.labelOptions, this.wrapperOptions);
    return this.inputWithWrapper();
  };

  Base.prototype.button = function(text, htmlOptions) {
    var options;
    if (htmlOptions == null) {
      htmlOptions = {};
    }
    options = _.defaults(htmlOptions, {
      "class": "btn btn-default"
    });
    return this.tagHelper.buttonTag(text, options);
  };

  return Base;

})();

if (window.JoB === void 0) {
  window.JoB = {};
}

if (JoB.SimpleForm === void 0) {
  window.JoB.SimpleForm = {};
}

JoB.SimpleForm.TranslationHelper = (function() {
  function TranslationHelper(base, _arg) {
    var hint, placeholder, translator, _ref;
    _ref = _arg != null ? _arg : {}, placeholder = _ref.placeholder, hint = _ref.hint, translator = _ref.translator;
    this.base = base;
    this.idetifier = "" + (this.base.ressourceName.toLowerCase()) + "." + (this.base.fieldName.toLowerCase());
    this.placeholderN = placeholder || 'simple_form.placeholders';
    this.hintN = hint || 'simple_form.hints';
    this.translator = (translator != null) && _.isFunction(translator) ? translator : typeof I18n !== "undefined" && I18n !== null ? (function(_this) {
      return function(identifier) {
        return I18n.t(identifier);
      };
    })(this) : function(identifier) {
      return identifier;
    };
  }

  TranslationHelper.prototype._base = function(namespace) {
    var name;
    name = this.translator("" + namespace + "." + this.idetifier);
    if ((name != null) && (name.match(this.idetifier) != null)) {
      name = false;
    }
    return name;
  };

  TranslationHelper.prototype.placeholder = function() {
    return this._base(this.placeholderN);
  };

  TranslationHelper.prototype.hint = function() {
    return this._base(this.hintN);
  };

  TranslationHelper.prototype.label = function() {
    var name;
    name = this._base('simple_form.labels');
    if (name === false) {
      name = this._base('activerecord.attributes');
    }
    if (name === false) {
      name = this.base.fieldName;
    }
    return name;
  };

  return TranslationHelper;

})();

if (window.JoB === void 0) {
  window.JoB = {};
}

if (JoB.SimpleForm === void 0) {
  window.JoB.SimpleForm = {};
}

JoB.SimpleForm.WrapperHelper = (function() {
  function WrapperHelper(base, simpleFormOptions, labelOptions, wrapperOptions) {
    this.base = base;
    this.simpleFormOptions = simpleFormOptions;
    this.labelOptions = labelOptions;
    this.options = _.defaults(wrapperOptions, {
      "class": 'form-group',
      addonText: false,
      addonPosition: 'left'
    });
    this.formTagHelper = new JoB.Form.TagHelper();
    this.tagHelper = new JoB.Lib.Tag();
    this.translationHelper = new JoB.SimpleForm.TranslationHelper(this.base);
  }

  WrapperHelper.prototype._labelText = function(label) {
    var text;
    text = "";
    if (_.isString(label)) {
      text = label;
    } else {
      text = this.translationHelper.label();
    }
    return text;
  };

  WrapperHelper.prototype._label = function() {
    if (this.simpleFormOptions.label === false) {
      return "";
    } else {
      return this.formTagHelper.labelTag(this.base.ressourceName, this.base.fieldName, this._labelText(this.simpleFormOptions.label), this.labelOptions);
    }
  };

  WrapperHelper.prototype._hint = function(text) {
    return this.tagHelper.contentTag('span', text, {
      "class": 'help-block'
    });
  };

  WrapperHelper.prototype._addon = function(addonText) {
    return this.tagHelper.contentTag('span', addonText, {
      "class": 'input-group-addon'
    });
  };

  WrapperHelper.prototype["default"] = function(inputHtml) {
    var html;
    html = "";
    html += "<div class='" + this.options["class"] + "'>";
    if (this.options.addonText === false) {
      html += this._label(this.simpleFormOptions.label);
      html += inputHtml;
    } else {
      html += this._label(this.simpleFormOptions.label);
      html += "<div class='input-group'>";
      if (this.options.addonPosition === 'left') {
        html += this.inputHtmlAddon(this.options.addonText);
        html += inputHtml;
      } else {
        html += inputHtml;
        html += this._addon(this.options.addonText);
      }
      html += '</div>';
    }
    if (_.isEmpty("" + this.simpleFormOptions.hint) === !true) {
      html += this._hint(this.simpleFormOptions.hint);
    }
    html += '</div>';
    return html;
  };

  WrapperHelper.prototype.checkbox = function(inputTag, labelText) {
    return "<div class='checkbox'><label>" + inputTag + labelText + "</label></div>";
  };

  WrapperHelper.prototype.radiobutton = function(inputTag, labelText) {
    return "<div class='radio'><label>" + inputTag + labelText + "</label></div>";
  };

  WrapperHelper.prototype.radiobuttons = function(inputs) {
    var html;
    html = "";
    _.each(inputs, (function(_this) {
      return function(input) {
        return html += _this.radiobutton(input, "");
      };
    })(this));
    return html;
  };

  return WrapperHelper;

})();

/*
//# sourceMappingURL=simple_form.js.map
*/
