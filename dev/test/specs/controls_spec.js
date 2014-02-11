// Generated by CoffeeScript 1.6.2
(function() {
  define(['jquery', 'js-fixtures'], function($, fixtures) {
    return describe("Controls", function() {
      var simpleForm;

      simpleForm = null;
      beforeEach(function() {
        return simpleForm = new ST.SimpleForm();
      });
      afterEach(function() {
        return fixtures.cleanUp();
      });
      return it("shold render default text field", function() {
        var input;

        fixtures.load("controls.html");
        console.log($(fixtures.body()).filter('.form-group'));
        input = simpleForm.input('account', 'name');
        return input.should.equal(fixtures.body());
      });
    });
  });

}).call(this);