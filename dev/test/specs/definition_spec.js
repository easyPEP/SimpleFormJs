// Generated by CoffeeScript 1.6.2
(function() {
  define(['jquery', 'js-fixtures'], function($, fixtures) {
    return describe("_includeBlankDefinition", function() {
      var simpleForm;

      simpleForm = null;
      beforeEach(function() {
        return simpleForm = new ST.SimpleForm();
      });
      afterEach(function() {
        return fixtures.cleanUp();
      });
      return it("sample equal assertion", function() {
        return simpleForm.input('account', 'name');
      });
    });
  });

}).call(this);