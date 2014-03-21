var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

window.ST = {};

ST.Error = {};

ST.Error.Arguments = (function(_super) {
  __extends(Arguments, _super);

  function Arguments(argument) {
    throw new Error("" + argument + " not provided");
  }

  return Arguments;

})(Error);

ST.CollectionHelper = (function() {
  function CollectionHelper() {}

  CollectionHelper.prototype.collectionParser = function(collection) {
    var converted;
    converted = [];
    if (this.options.includeBlank !== false) {
      converted.push({
        value: "",
        text: this.options.includeBlank != null ? this.options.includeBlank : ''
      });
    }
    _.each(collection, function(element) {
      if (_.isArray(element) && element.length === 2) {
        return converted.push({
          value: element[0],
          text: element[1]
        });
      } else if (_.isBoolean(element) || _.isString(element)) {
        return converted.push({
          value: element,
          text: element
        });
      }
    });
    return converted;
  };

  return CollectionHelper;

})();

ST.TranslationHelper = (function() {
  function TranslationHelper() {}

  TranslationHelper.prototype._translatedPlaceholder = function() {
    var idetifier, name;
    idetifier = "" + (this.base.ressourceName.toLowerCase()) + "." + (this.base.fieldName.toLowerCase());
    name = this.translator("simple_form.placeholders." + idetifier);
    if ((name != null) && (name.match(idetifier) != null)) {
      name = false;
    }
    return name;
  };

  TranslationHelper.prototype.translatedHint = function() {
    var idetifier, name;
    idetifier = "" + (this.base.ressourceName.toLowerCase()) + "." + (this.base.fieldName.toLowerCase());
    name = this.translator("simple_form.hints." + idetifier);
    if (name.match(idetifier) != null) {
      name = false;
    }
    return name;
  };

  TranslationHelper.prototype.translatedLabelName = function() {
    var idetifier, name;
    idetifier = "" + (this.base.ressourceName.toLowerCase()) + "." + (this.base.fieldName.toLowerCase());
    name = this.translator("simple_form.labels." + idetifier);
    if ((name != null) && (name.match(idetifier) != null)) {
      name = this.translator("activerecord.attributes." + idetifier);
      if ((name != null) && (name.match(idetifier) != null)) {
        name = this.base.fieldName;
      }
    }
    if (!name) {
      name = false;
    }
    return name;
  };

  return TranslationHelper;

})();

ST.WrapperHelper = (function() {
  function WrapperHelper() {}

  WrapperHelper.prototype.wrapper = function(inputHtml) {
    var html;
    html = "";
    html += "<div class='" + this.options.wrapperClass + "'>";
    if (this.options.addonText === false) {
      html += this.label();
      html += inputHtml;
    } else {
      html += this.label();
      html += "<div class='input-group'>";
      if (this.options.addonPosition === 'left') {
        html += this.inputHtmlAddon(this.options.addonText);
        html += inputHtml;
      } else {
        html += inputHtml;
        html += this.inputAddon(this.options.addonText);
      }
      html += '</div>';
    }
    html += this.hint();
    html += '</div>';
    return html;
  };

  WrapperHelper.prototype.checkboxesWrapper = function(inputHtml) {
    var html;
    html = "<div class='" + this.options.wrapperClass + "'>";
    html += "<div class='checkbox'> <label> " + inputHtml + " " + this.options.label + "</label> </div>";
    html += "</div>";
    return html;
  };

  WrapperHelper.prototype.radiobuttonsWrapper = function(inputs) {
    var html;
    html = "<div class='" + this.options.wrapperClass + "'>";
    _.each(inputs, function(el) {
      return html += "<div class='radio'><label>" + el[0] + " " + el[1] + "</label></div>";
    });
    html += "</div>";
    return html;
  };

  return WrapperHelper;

})();

ST.MetaHelper = (function() {
  function MetaHelper() {}

  MetaHelper.prototype.inputValue = function() {
    var val;
    val = this.options.value === false || this.options.value === 'undefined' ? "" : this.options.as === 'text' ? this.options.value : 'text' ? "value='" + this.options.value + "'" : void 0;
    return val;
  };

  MetaHelper.prototype.checked = function(comparerator) {
    if (comparerator || comparerator === 'true') {
      return 'checked';
    }
  };

  MetaHelper.prototype.selected = function(selected, range) {
    if ((selected != null) && (range != null) && _.isArray(range)) {
      if (_.contains(range, selected)) {
        return 'selected=selected';
      }
    } else if (_.isBoolean(selected)) {
      if (selected) {
        return 'selected=selected';
      }
    }
  };

  MetaHelper.prototype.inputId = function() {
    return "" + (this.base.ressourceName.toLowerCase()) + "_" + (this.base.fieldName.toLowerCase());
  };

  MetaHelper.prototype.inputName = function() {
    return "" + (this.base.ressourceName.toLowerCase()) + "[" + (this.base.fieldName.toLowerCase()) + "]";
  };

  MetaHelper.prototype.inputMeta = function() {
    var string;
    string = "class='" + this.options.inputClass + "'";
    string += "name='" + (this.inputName()) + "' ";
    string += "id='" + (this.inputId()) + "' ";
    if (this.options.placeholder !== false) {
      string += "placeholder='" + this.options.placeholder + "' ";
    }
    return string;
  };

  MetaHelper.prototype.inputAddon = function(text) {
    return "<span class='input-group-addon'>" + text + "</span>";
  };

  return MetaHelper;

})();

ST.ControlHelper = (function() {
  function ControlHelper() {}

  ControlHelper.prototype._selectControl = function() {
    var collection, input;
    collection = this.options.collection;
    input = "";
    input += "<select " + (this.inputMeta()) + " >";
    _.each(this.options.collection, (function(_this) {
      return function(option) {
        return input += "<option " + (_this.selected(option.value === _this.options.value)) + " value='" + option.value + "'>" + option.text + "</option>";
      };
    })(this));
    return input += "</select>";
  };

  ControlHelper.prototype._booleanControl = function() {
    return console.log("not yet implemented");
  };

  ControlHelper.prototype._inputControl = function(type) {
    var input;
    input = "<input type='" + type + "'";
    if (!_.isEmpty(this.inputMeta())) {
      input += " " + (this.inputMeta());
    }
    if (!_.isEmpty(this.inputValue())) {
      input += " " + (this.inputValue());
    }
    return input += ">";
  };

  return ControlHelper;

})();

ST.DisplayHelper = (function() {
  function DisplayHelper() {}

  DisplayHelper.prototype.button = function(text) {
    var html;
    html = "<div class='" + this.options.wrapperClass + "'>";
    html += "<button type='submit' class='btn btn-default'>" + text + "</button>";
    html += "</div>";
    return html;
  };

  DisplayHelper.prototype.inputInput = function() {
    return this.wrapper(this._inputControl(this.options.as));
  };

  DisplayHelper.prototype.textareaInput = function() {
    var input;
    input = "<textarea " + (this.inputMeta()) + ">" + (this.inputValue()) + "</textarea>";
    return this.wrapper(input);
  };

  DisplayHelper.prototype.checkboxesInput = function() {
    var input;
    input = "<input " + (this.inputMeta()) + " type='checkbox' " + (this.inputValue()) + ">";
    return this["" + this.options.typeName + "Wrapper"](input);
  };

  DisplayHelper.prototype.radiobuttonsInput = function() {
    var els;
    els = [];
    _.each(this.options.collection, (function(_this) {
      return function(option) {
        return els.push(["<input type='radio' " + (_this.inputMeta()) + " value='" + option.value + "'>", option.text]);
      };
    })(this));
    return this["" + this.options.typeName + "Wrapper"](els);
  };

  DisplayHelper.prototype.fileInput = function() {
    var input;
    input = "<input type='" + this.options.type + "' " + (this.inputMeta()) + ">";
    return this.wrapper(input);
  };

  DisplayHelper.prototype.selectInput = function() {
    var input;
    input = this._selectControl();
    return this.wrapper(input);
  };

  DisplayHelper.prototype.label = function() {
    if (this.options.label === false) {
      return "";
    } else {
      return "<label for='" + (this.inputId()) + "'>" + this.options.label + "</label>";
    }
  };

  DisplayHelper.prototype.hint = function() {
    if (this.options.hint === false) {
      return "";
    } else {
      return "<span class='help-block'>" + this.options.hint + "</span>";
    }
  };

  return DisplayHelper;

})();

ST.SimpleForm = (function() {
  var INPUT_MAPPING;

  _.extend(SimpleForm.prototype, ST.TranslationHelper.prototype, ST.CollectionHelper.prototype, ST.DisplayHelper.prototype, ST.WrapperHelper.prototype, ST.MetaHelper.prototype, ST.ControlHelper.prototype);

  INPUT_MAPPING = {
    boolean: 'input',
    string: 'input',
    email: 'input',
    url: 'input',
    tel: 'input',
    password: 'input',
    search: 'input',
    file: 'input',
    hidden: 'input',
    integer: 'input',
    float: 'input',
    decimal: 'input',
    range: 'input',
    radiobuttons: 'radiobuttons',
    checkboxes: 'checkboxes',
    text: 'textarea',
    textarea: 'textarea',
    datetime: 'select',
    date: 'select',
    time: 'select',
    select: 'select'
  };

  SimpleForm.prototype._translatorFunction = function(translator) {
    return this.translator = translator != null ? translator : typeof I18n !== "undefined" && I18n !== null ? (function(_this) {
      return function(identifier) {
        return I18n.t(identifier);
      };
    })(this) : function(identifier) {
      return identifier;
    };
  };

  function SimpleForm(_arg) {
    var translator;
    translator = (_arg != null ? _arg : {}).translator;
    this._translatorFunction(translator);
  }

  SimpleForm.prototype._argumentsValidator = function(args) {
    if (args[0] == null) {
      new ST.Error.Arguments('ressource');
    }
    if (args[1] == null) {
      return new ST.Error.Arguments('ressourceFieldName');
    }
  };

  SimpleForm.prototype._ressoureDefinition = function(ressource) {
    if (_.isString(ressource)) {
      this.base.ressourceName = ressource;
      return this.base.ressource = false;
    } else if (_.isObject(ressource)) {
      if (ressource.modelName != null) {
        this.base.ressourceName = ressource.modelName;
        return this.base.ressource = ressource;
      } else if (ressource.className != null) {
        this.base.ressourceName = ressource.className;
        return this.base.ressource = ressource;
      } else {
        this.base.ressourceName = ressource;
        return this.base.ressource = ressource;
      }
    }
  };

  SimpleForm.prototype._inputValueDefinition = function(value) {
    return this.options.value = value != null ? value : _.isObject(this.base.ressource) ? _.isFunction(this.base.ressource.get) ? this.base.ressource.get(this.base.fieldName) : this.base.ressource[this.base.fieldName] : false;
  };

  SimpleForm.prototype._collectionDefinition = function(collection) {
    if (collection != null) {
      this.options.collection = this.collectionParser(collection);
      if (this.options.as === 'string') {
        return this.options.as = 'select';
      }
    }
  };

  SimpleForm.prototype._placeHolderDefinition = function(placeholder) {
    var translatedPlaceholder;
    return this.options.placeholder = placeholder === false ? false : placeholder != null ? placeholder : (translatedPlaceholder = this._translatedPlaceholder(), translatedPlaceholder != null ? translatedPlaceholder : false);
  };

  SimpleForm.prototype._labelDefinition = function(label) {
    return this.options.label = label === false ? false : label != null ? label : label = this.translatedLabelName();
  };

  SimpleForm.prototype._hintDefinition = function(hint) {
    return this.options.hint = hint === false ? false : hint != null ? hint != null ? hint : hint = this.translatedHint() : false;
  };

  SimpleForm.prototype._wrapperClassDefinition = function(wrapperClass) {
    var wrapperClassNames;
    wrapperClassNames = [];
    wrapperClassNames.push('form-group');
    if (wrapperClass != null) {
      wrapperClassNames.push(wrapperClass);
    }
    return this.options.wrapperClass = wrapperClassNames.join(" ");
  };

  SimpleForm.prototype._inputClassDefinition = function(inputClass) {
    var inputClassNames, inputMapping;
    inputMapping = INPUT_MAPPING["" + this.options.as];
    inputClassNames = ["form-" + inputMapping];
    if (inputMapping === 'input' || inputMapping === 'textarea' || inputMapping === 'select') {
      inputClassNames.push('form-control');
    }
    if (inputClass != null) {
      inputClassNames.push(inputClass);
    }
    return this.options.inputClass = inputClassNames.join(" ");
  };

  SimpleForm.prototype._includeBlankDefinition = function(includeBlank) {
    return this.options.includeBlank = (function() {
      if ((includeBlank != null) && _.isString(includeBlank)) {
        return includeBlank;
      } else if (includeBlank === true) {
        return true;
      } else if (includeBlank === false) {
        return false;
      } else if (_.isString(this.options.as)) {
        switch (this.options.as) {
          case 'radiobuttons':
            return false;
          case 'checkboxes':
            return false;
        }
      } else {
        return true;
      }
    }).call(this);
  };

  SimpleForm.prototype.input = function(ressource, fieldName, _arg) {
    var addonPosition, addonText, as, collection, hint, includeBlank, inputClass, label, model, placeholder, required, translator, type, value, wrapperClass, _ref;
    _ref = _arg != null ? _arg : {}, model = _ref.model, collection = _ref.collection, value = _ref.value, label = _ref.label, hint = _ref.hint, as = _ref.as, required = _ref.required, placeholder = _ref.placeholder, type = _ref.type, addonText = _ref.addonText, addonPosition = _ref.addonPosition, includeBlank = _ref.includeBlank, inputClass = _ref.inputClass, wrapperClass = _ref.wrapperClass, translator = _ref.translator;
    this._argumentsValidator(arguments);
    this.base = {
      fieldName: fieldName
    };
    this.options = {
      as: as != null ? as : as = 'string',
      type: type != null ? type : type = 'text',
      required: required != null ? required : required = false,
      addonText: addonText != null ? addonText : addonText = false,
      addonPosition: addonPosition != null ? addonPosition : addonPosition = 'right'
    };
    this._ressoureDefinition(ressource);
    this._translatorFunction(translator);
    this._includeBlankDefinition(includeBlank);
    this._inputValueDefinition(value);
    this._collectionDefinition(collection);
    this._placeHolderDefinition(placeholder);
    this._labelDefinition(label);
    this._hintDefinition(hint);
    this._wrapperClassDefinition(wrapperClass);
    this._inputClassDefinition(inputClass);
    this.options.typeName = INPUT_MAPPING["" + this.options.as];
    return this["" + this.options.typeName + "Input"]();
  };

  return SimpleForm;

})();
