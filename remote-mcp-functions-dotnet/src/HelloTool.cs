using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Extensions.Mcp;
using Microsoft.Extensions.Logging;
using static FunctionsSnippetTool.ToolsInformation;

namespace FunctionsSnippetTool;

public class HelloTool(ILogger<HelloTool> logger)
{
    [Function(nameof(SayHello))]
    public string SayHello(
        [McpToolTrigger(HelloToolName, HelloToolDescription)] ToolInvocationContext context
    )
    {
        logger.LogInformation("Saying hello");
        return "Hello I am MCP Tool!";
    }

    [Function(nameof(WhoAmI))]
    public string WhoAmI(
    [McpToolTrigger(WhoAmIToolName, WhoAmIToolDescription)] ToolInvocationContext context
)
    {
        logger.LogInformation("Saying hello");
        return "Hello I am Dataverse Tool!";
    }

    [Function(nameof(Capacity))]
    public string Capacity(
    [McpToolTrigger(CapacityToolName, CapacityToolDescription)] ToolInvocationContext context
    )
    {
        logger.LogInformation("Saying hello");
        return "Hello I am Dataverse Tool!";
    }

}
