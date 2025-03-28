require "tools.strings"
local math = require "math"

---Generates V4 UUID.
---@return string
local function uuid()
  local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function(c)
    local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
    return string.format('%x', v)
  end)
end

local M = {}

---@generic Key, Value
---@class Record<Key, Value>: { [Key]: Value }

---@alias Describer fun()

---@type Record<string, Describer>
local describers = {}

local describe_stack


---comment
---@param subject string
---@param describer Describer
function M.describe(subject, describer)
  if describers[subject] then
    error("Are you bufo? Describe with subject " .. subject:quote() .. " already exists.")
  end
  describers[subject] = describer
end

local test_suits = {}

---comment
---@param assumption string
---@param expectations fun()
function M.it(assumption, expectations)

end

local failed_test_count = 0

---@alias ArgumentlessPredicate fun(): boolean?

---@class Expectation
---@field toBeTrue fun(self: Expectation<boolean?>)
---@field toBeZero fun(self: Expectation<number>)

---@generic T: boolean?
---@class Expectation<T>
---@field toBeTrue fun(self: Expectation<boolean?>)


---@generic T: number
---@class Expectation<T>
---@field toBeZero fun(self: Expectation<number>)

---@generic T
---@class TestSuite
---@field expect fun(self: TestSuite, value: T): Expectation<T>
---@field expect_true fun(self: TestSuite, predicate: ArgumentlessPredicate, message: string)
---@field failed_test_count fun(self: TestSuite): integer


local Expectation = {
  ---Creates an expectation.
  ---@generic T
  ---@param value T a value
  ---@param pass fun(message: string) handler for passed test
  ---@param fail fun(message: string) handler for failed test
  ---@return Expectation<T>
  new = function(value, pass, fail)
    local expectation = {}

    --[PRIVATE FIELDS]--------------------------------------------------------------

    expectation._value = value
    ---@type string?
    expectation._context = nil

    --[PUBLIC METHODS]--------------------------------------------------------------

    ---Creates a well formatted message for pass and fail.
    ---@param context string?
    ---@param message string?
    local function create_test_result_message(context, message)
      if not message then
        return (context or "")
      end

      return (context or "") .. " " .. message
    end

    ---Expects that the passed value is true.
    ---@param self Expectation<boolean?>
    expectation.toBeTrue = function(self)
      if type(self._value) == "boolean" or type(self._value) == "nil" then
        if self._value then
          pass(create_test_result_message(expectation._context))
        else
          fail(create_test_result_message(expectation._context, 'expected to be "true" but actually "false"'))
        end
      else
        fail(create_test_result_message(expectation._context, "value isn't of a boolean type."))
      end
    end

    return expectation
  end
}

local TestSuite = {
  ---Creates a new TestSuite.
  ---@return TestSuite
  new = function()
    local suite = {}

    --[PRIVATE FIELDS]--------------------------------------------------------------

    suite._failed_tests_count = 0

    --[PUBLIC METHODS]--------------------------------------------------------------

    ---Returns a number of failed tests.
    ---@param self TestSuite
    ---@return integer
    function suite.failed_test_count(self)
      ---@diagnostic disable-next-line: undefined-field
      return self._failed_tests_count
    end

    ---Creates expectation over provided value.
    ---@generic T
    ---@param self TestSuite
    ---@param value T
    ---@return Expectation<T>
    function suite.expect(self, value)
      local pass = function(message)
        suite._pass(message)
      end

      local fail = function(message)
        suite:_fail(message)
      end

      return Expectation.new(value, pass, fail)
    end

    ---Pass the test if predicate evaluates to true, if evaluates to false then fails.
    ---@param predicate ArgumentlessPredicate
    ---@param message string
    function suite.expect_true(self, predicate, message)
      if predicate() then
        ---@diagnostic disable-next-line: undefined-field
        self._pass(message)
      else
        ---@diagnostic disable-next-line: undefined-field
        self:_fail(message)
      end
    end

    --[PRIVATE METHODS]-------------------------------------------------------------

    ---Prints the pass message with the given argument.
    ---@param message string
    function suite._pass(message)
      print("[PASS]:" .. message)
    end

    ---Prints the fail message with the given argument.
    ---@param self TestSuite
    ---@param message string
    function suite._fail(self, message)
      print("[FAIL]:" .. message)
      ---@diagnostic disable-next-line: undefined-field, inject-field
      self._failed_test_count = self._failed_test_count + 1;
    end

    return suite
  end
}

function M.create_suite()
  return TestSuite.new()
end

return M
