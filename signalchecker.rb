
require './testenv'
require './agent'

agent = Agent.new

TestEnv.run agent
TestEnv.output

