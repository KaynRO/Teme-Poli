import java.util.ArrayList;

//Based on what command we have, we create it's specific class instance using Singleton patternx
public class CommandFactory {
    private static CommandFactory instance = null;

    private CommandFactory() {

    }

    public static CommandFactory getInstance() {
        if (instance == null)
            instance = new CommandFactory();
        return instance;
    }

    Command getCommand(String command, ArrayList<String> arguments) {
        switch (command) {
            case "mv":
                return new CommandMV(arguments);
            case "ls":
                return new CommandLS(arguments);
            case "pwd":
                return new CommandPWD();
            case "rm":
                return new CommandRM(arguments);
            case "cp":
                return new CommandCP(arguments);
            case "touch":
                return new CommandTOUCH(arguments);
            case "mkdir":
                return new CommandMKDIR(arguments);
        }
        return new CommandCD(arguments);
    }
}