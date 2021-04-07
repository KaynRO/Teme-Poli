//Get current working directory
class CommandPWD extends Command {

    CommandPWD() {
    }

    public ResultCollector execute() {

        ResultCollector resultCollector = new ResultCollector();
        resultCollector.setOutput(fileSystem.pwd(fileSystem.getCurrentDirectory()) + "\n");

        return resultCollector;
    }
}
