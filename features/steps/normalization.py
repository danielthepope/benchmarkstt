import subprocess

from behave import given, when, then # pylint: disable=no-name-in-module
from hamcrest import assert_that, equal_to

EXECUTABLE = 'benchmarkstt-tools'
COMMON_FLAGS = 'normalization'

@given('the input "{text}"')
def given_the_input(context, text):
    context.input_text = text


@when('I run the normalizer with the arguments "{args}"')
def when_run_with_options(context, args):
    run_normalizer(context, args)


@when('I run the normalizer with the following arguments')
def when_run_with_more_options(context):
    args = context.text
    run_normalizer(context, args)


def run_normalizer(context, args):
    command = '%s %s %s' % (EXECUTABLE, COMMON_FLAGS, args)
    print(command)
    input_text = context.input_text.encode('utf-8')
    print('IN: %s' % input_text)
    result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, input=input_text, shell=True)
    print('OUT: %s' % result.stdout)
    context.output = result.stdout.decode('utf-8')



@then('the output should be "{text}"')
def then_output_is(context, text):
    assert_that(context.output, equal_to(text))


