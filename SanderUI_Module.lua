--[=[
 d888b  db    db d888888b      .d888b.      db      db    db  .d8b.  
88' Y8b 88    88   `88'        VP  `8D      88      88    88 d8' `8b 
88      88    88    88            odD'      88      88    88 88ooo88 
88  ooo 88    88    88          .88'        88      88    88 88~~~88 
88. ~8~ 88b  d88   .88.        j88.         88booo. 88b  d88 88   88    @uniquadev
 Y888P  ~Y8888P' Y888888P      888888D      Y88888P ~Y8888P' YP   YP  CONVERTER 
]=]

local G2L = {};

-- ⚡ GİZLİLİK İÇİN COREGUI KULLANIMI ⚡
local coreGui = game:GetService("CoreGui")
local runService = game:GetService("RunService")
local targetGui = runService:IsStudio() and game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") or coreGui

-- Eski Arayüzü Temizle (Üst üste binmemesi için)
if targetGui:FindFirstChild("SanderUI") then
    targetGui.SanderUI:Destroy()
end

G2L["1"] = Instance.new("ScreenGui", targetGui);
G2L["1"]["Name"] = [[SanderUI]];
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;

-- StarterGui.SanderUI.MainFrame
G2L["3"] = Instance.new("ImageLabel", G2L["1"]);
G2L["3"]["BorderSizePixel"] = 0;
G2L["3"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["3"]["Image"] = [[rbxassetid://111272823017744]];
G2L["3"]["Size"] = UDim2.new(0, 400, 0, 427);
G2L["3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["3"]["BackgroundTransparency"] = 1;
G2L["3"]["Name"] = [[MainFrame]];
G2L["3"]["Position"] = UDim2.new(0.09408, 0, 0.02738, 0);

G2L["4"] = Instance.new("Frame", G2L["3"]);
G2L["4"]["BorderSizePixel"] = 0;
G2L["4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["4"]["Size"] = UDim2.new(0, 400, 0, 100);
G2L["4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["4"]["Name"] = [[TopBar]];
G2L["4"]["BackgroundTransparency"] = 1;

G2L["5"] = Instance.new("TextLabel", G2L["3"]);
G2L["5"]["BorderSizePixel"] = 0;
G2L["5"]["TextSize"] = 14;
G2L["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["5"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["5"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5"]["BackgroundTransparency"] = 1;
G2L["5"]["Size"] = UDim2.new(0, 72, 0, 13);
G2L["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5"]["Name"] = [[CustomTxt]];
G2L["5"]["Position"] = UDim2.new(0.8025, 0, 0.09836, 0);

G2L["6"] = Instance.new("UIStroke", G2L["5"]);
G2L["6"]["Thickness"] = 0.5;

G2L["7"] = Instance.new("ScrollingFrame", G2L["3"]);
G2L["7"]["Active"] = true;
G2L["7"]["BorderSizePixel"] = 0;
G2L["7"]["Name"] = [[Sidebar]];
G2L["7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["7"]["Size"] = UDim2.new(0, 116, 0, 303);
G2L["7"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
G2L["7"]["Position"] = UDim2.new(0.035, 0, 0.25293, 0);
G2L["7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["7"]["ScrollBarThickness"] = 1;
G2L["7"]["BackgroundTransparency"] = 1;

G2L["8"] = Instance.new("UIListLayout", G2L["7"]);
G2L["8"]["Padding"] = UDim.new(0, 5);
G2L["8"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

G2L["9"] = Instance.new("ScrollingFrame", G2L["3"]);
G2L["9"]["Active"] = true;
G2L["9"]["BorderSizePixel"] = 0;
G2L["9"]["Name"] = [[PageTemplate]];
G2L["9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["9"]["Size"] = UDim2.new(0, 250, 0, 270);
G2L["9"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
G2L["9"]["Position"] = UDim2.new(0.35, 0, 0.33021, 0);
G2L["9"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["9"]["ScrollBarThickness"] = 2;
G2L["9"]["BackgroundTransparency"] = 1;

G2L["a"] = Instance.new("TextButton", G2L["3"]);
G2L["a"]["BorderSizePixel"] = 0;
G2L["a"]["TextSize"] = 14;
G2L["a"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["a"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["a"]["BackgroundTransparency"] = 1;
G2L["a"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["a"]["Text"] = [[]];
G2L["a"]["Name"] = [[MinimizeBtn]];
G2L["a"]["Position"] = UDim2.new(0.837, 1, 0.04, 0);

G2L["b"] = Instance.new("TextButton", G2L["3"]);
G2L["b"]["BorderSizePixel"] = 0;
G2L["b"]["TextSize"] = 14;
G2L["b"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["b"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["b"]["BackgroundTransparency"] = 1;
G2L["b"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["b"]["Text"] = [[]];
G2L["b"]["Name"] = [[HomeBtn]];
G2L["b"]["Position"] = UDim2.new(0.772, 2, 0.03981, 0);

G2L["c"] = Instance.new("TextButton", G2L["3"]);
G2L["c"]["BorderSizePixel"] = 0;
G2L["c"]["TextSize"] = 14;
G2L["c"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["c"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["c"]["BackgroundTransparency"] = 1;
G2L["c"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["c"]["Text"] = [[]];
G2L["c"]["Name"] = [[SettingsBtn]];
G2L["c"]["Position"] = UDim2.new(0.7, 6, 0.03981, 0);

G2L["d"] = Instance.new("TextButton", G2L["3"]);
G2L["d"]["BorderSizePixel"] = 0;
G2L["d"]["TextSize"] = 14;
G2L["d"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["d"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["d"]["BackgroundTransparency"] = 1;
G2L["d"]["Size"] = UDim2.new(0, 20, 0, 20);
G2L["d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["d"]["Text"] = [[]];
G2L["d"]["Name"] = [[CloseBtn]];
G2L["d"]["Position"] = UDim2.new(0.9025, 0, 0.03981, 0);

G2L["e"] = Instance.new("TextLabel", G2L["3"]);
G2L["e"]["TextWrapped"] = true;
G2L["e"]["BorderSizePixel"] = 0;
G2L["e"]["TextSize"] = 9;
G2L["e"]["TextScaled"] = true;
G2L["e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["e"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["e"]["BackgroundTransparency"] = 1;
G2L["e"]["Size"] = UDim2.new(0, 248, 0, 96);
G2L["e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["e"]["Text"] = [[Sander UI]];
G2L["e"]["Name"] = [[LogoText]];
G2L["e"]["Position"] = UDim2.new(0.045, 0, 0.01171, 0);

G2L["f"] = Instance.new("UIStroke", G2L["e"]);
G2L["f"]["Color"] = Color3.fromRGB(44, 44, 44);

G2L["10"] = Instance.new("TextLabel", G2L["3"]);
G2L["10"]["BorderSizePixel"] = 0;
G2L["10"]["TextSize"] = 14;
G2L["10"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["10"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["10"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["10"]["BackgroundTransparency"] = 1;
G2L["10"]["Size"] = UDim2.new(0, 49, 0, 13);
G2L["10"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["10"]["Text"] = [[Fps]];
G2L["10"]["Name"] = [[CustomText]];
G2L["10"]["Position"] = UDim2.new(0.71, 0, 0.07766, 8);

G2L["11"] = Instance.new("UIStroke", G2L["10"]);
G2L["11"]["Thickness"] = 0.5;

G2L["12"] = Instance.new("TextBox", G2L["3"]);
G2L["12"]["Name"] = [[SearchBar]];
G2L["12"]["PlaceholderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["12"]["BorderSizePixel"] = 0;
G2L["12"]["TextWrapped"] = true;
G2L["12"]["TextTransparency"] = 0.5;
G2L["12"]["TextSize"] = 20;
G2L["12"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["12"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["12"]["RichText"] = true;
G2L["12"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["12"]["PlaceholderText"] = [[Arama Yap...]];
G2L["12"]["Size"] = UDim2.new(0, 243, 0, 27);
G2L["12"]["Position"] = UDim2.new(0.3575, 0, 0.25293, 0);
G2L["12"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["12"]["Text"] = [[]];
G2L["12"]["BackgroundTransparency"] = 1;

G2L["13"] = Instance.new("UIStroke", G2L["12"]);
G2L["13"]["Thickness"] = 0.5;

G2L["14"] = Instance.new("Folder", G2L["1"]);
G2L["14"]["Name"] = [[Templates]];

G2L["15"] = Instance.new("ImageButton", G2L["14"]);
G2L["15"]["BorderSizePixel"] = 0;
G2L["15"]["Visible"] = false;
G2L["15"]["BackgroundTransparency"] = 1;
G2L["15"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["15"]["Image"] = [[rbxassetid://138995942309329]];
G2L["15"]["Size"] = UDim2.new(0, 68, 0, 37);
G2L["15"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["15"]["Name"] = [[ButtonTemplate]];
G2L["15"]["Position"] = UDim2.new(0.89513, 0, 0.32378, 0);

G2L["16"] = Instance.new("UIStroke", G2L["15"]);
G2L["16"]["Color"] = Color3.fromRGB(45, 45, 45);

G2L["17"] = Instance.new("UICorner", G2L["15"]);
G2L["17"]["CornerRadius"] = UDim.new(0, 9);

G2L["18"] = Instance.new("TextLabel", G2L["15"]);
G2L["18"]["TextWrapped"] = true;
G2L["18"]["BorderSizePixel"] = 0;
G2L["18"]["TextSize"] = 14;
G2L["18"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["18"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["18"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["18"]["BackgroundTransparency"] = 1;
G2L["18"]["RichText"] = true;
G2L["18"]["Size"] = UDim2.new(0, 68, 0, 37);
G2L["18"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["18"]["Text"] = [[label]];
G2L["18"]["Name"] = [[Text1]];
G2L["18"]["Position"] = UDim2.new(-0.00529, 0, 0, 0);

G2L["19"] = Instance.new("ImageButton", G2L["14"]);
G2L["19"]["BorderSizePixel"] = 0;
G2L["19"]["Visible"] = false;
G2L["19"]["BackgroundTransparency"] = 1;
G2L["19"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["19"]["Image"] = [[rbxassetid://138995942309329]];
G2L["19"]["Size"] = UDim2.new(0, 111, 0, 37);
G2L["19"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["19"]["Name"] = [[ButtonTemplate2]];
G2L["19"]["Position"] = UDim2.new(0.85291, 0, 0.39626, 0);

G2L["1a"] = Instance.new("UIStroke", G2L["19"]);
G2L["1a"]["Color"] = Color3.fromRGB(45, 45, 45);

G2L["1b"] = Instance.new("UICorner", G2L["19"]);
G2L["1b"]["CornerRadius"] = UDim.new(0, 11);

G2L["1c"] = Instance.new("TextLabel", G2L["19"]);
G2L["1c"]["TextWrapped"] = true;
G2L["1c"]["BorderSizePixel"] = 0;
G2L["1c"]["TextSize"] = 14;
G2L["1c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1c"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1c"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1c"]["BackgroundTransparency"] = 1;
G2L["1c"]["RichText"] = true;
G2L["1c"]["Size"] = UDim2.new(0, 111, 0, 37);
G2L["1c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1c"]["Text"] = [[label]];
G2L["1c"]["Name"] = [[Text2]];
G2L["1c"]["Position"] = UDim2.new(0.00488, 0, 0, 0);

G2L["1d"] = Instance.new("Frame", G2L["14"]);
G2L["1d"]["BorderSizePixel"] = 0;
G2L["1d"]["BackgroundColor3"] = Color3.fromRGB(9, 9, 9);
G2L["1d"]["Size"] = UDim2.new(0, 62, 0, 32);
G2L["1d"]["Position"] = UDim2.new(0.89798, 0, 0.47358, 0);
G2L["1d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1d"]["Name"] = [[ToggleTemplate]];

G2L["1e"] = Instance.new("UICorner", G2L["1d"]);
G2L["1e"]["CornerRadius"] = UDim.new(1, 8);

G2L["1f"] = Instance.new("UIStroke", G2L["1d"]);
G2L["1f"]["Color"] = Color3.fromRGB(45, 45, 45);

G2L["20"] = Instance.new("TextButton", G2L["1d"]);
G2L["20"]["BorderSizePixel"] = 0;
G2L["20"]["TextSize"] = 14;
G2L["20"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["20"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["20"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["20"]["Size"] = UDim2.new(0, 28, 0, 28);
G2L["20"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["20"]["Text"] = [[]];
G2L["20"]["Name"] = [[ToggleButton]];
G2L["20"]["Visible"] = false;
G2L["20"]["Position"] = UDim2.new(0.435, 5, 0.06349, 0);

G2L["21"] = Instance.new("UICorner", G2L["20"]);
G2L["21"]["CornerRadius"] = UDim.new(1, 8);

G2L["22"] = Instance.new("TextLabel", G2L["1d"]);
G2L["22"]["TextWrapped"] = true;
G2L["22"]["BorderSizePixel"] = 0;
G2L["22"]["TextSize"] = 14;
G2L["22"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["22"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["22"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["22"]["BackgroundTransparency"] = 1;
G2L["22"]["RichText"] = true;
G2L["22"]["Size"] = UDim2.new(0, 73, 0, 37);
G2L["22"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["22"]["Text"] = [[label]];
G2L["22"]["Name"] = [[ToggleText]];
G2L["22"]["Position"] = UDim2.new(-1.15641, 0, -0.09375, 0);

G2L["23"] = Instance.new("UIStroke", G2L["22"]);
G2L["23"]["Thickness"] = 0.5;

G2L["24"] = Instance.new("TextButton", G2L["1d"]);
G2L["24"]["BorderSizePixel"] = 0;
G2L["24"]["TextSize"] = 14;
G2L["24"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["24"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["24"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["24"]["Size"] = UDim2.new(0, 28, 0, 28);
G2L["24"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["24"]["Text"] = [[]];
G2L["24"]["Name"] = [[ToggleButton]];
G2L["24"]["Position"] = UDim2.new(0.015, 1, 0.032, 1);

G2L["25"] = Instance.new("UICorner", G2L["24"]);
G2L["25"]["CornerRadius"] = UDim.new(1, 8);

G2L["26"] = Instance.new("ImageButton", G2L["14"]);
G2L["26"]["BorderSizePixel"] = 0;
G2L["26"]["Visible"] = false;
G2L["26"]["BackgroundTransparency"] = 1;
G2L["26"]["BackgroundColor3"] = Color3.fromRGB(76, 76, 76);
G2L["26"]["Image"] = [[rbxassetid://138995942309329]];
G2L["26"]["Size"] = UDim2.new(0, 116, 0, 36);
G2L["26"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["26"]["Name"] = [[TabTemplate]];
G2L["26"]["Position"] = UDim2.new(0.84808, 0, 0.24982, 0);

G2L["27"] = Instance.new("TextLabel", G2L["26"]);
G2L["27"]["BorderSizePixel"] = 0;
G2L["27"]["TextSize"] = 14;
G2L["27"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["27"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["27"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["27"]["BackgroundTransparency"] = 1;
G2L["27"]["Size"] = UDim2.new(0, 115, 0, 36);
G2L["27"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["27"]["Name"] = [[TextTemplate]];

G2L["28"] = Instance.new("Frame", G2L["26"]);
G2L["28"]["BorderSizePixel"] = 0;
G2L["28"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["28"]["Size"] = UDim2.new(0, 2, 0, 36);
G2L["28"]["Position"] = UDim2.new(0.00414, 0, -0.02485, 0);
G2L["28"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["28"]["Name"] = [[Indicator]];

G2L["29"] = Instance.new("UICorner", G2L["28"]);

G2L["2a"] = Instance.new("ImageLabel", G2L["1"]);
G2L["2a"]["BorderSizePixel"] = 0;
G2L["2a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["2a"]["Image"] = [[rbxassetid://134457624041336]];
G2L["2a"]["Size"] = UDim2.new(0, 400, 0, 75);
G2L["2a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2a"]["BackgroundTransparency"] = 1;
G2L["2a"]["Name"] = [[Mini Frame]];
G2L["2a"]["Position"] = UDim2.new(0.41358, 0, 0.02738, 0);

G2L["2b"] = Instance.new("TextLabel", G2L["2a"]);
G2L["2b"]["TextWrapped"] = true;
G2L["2b"]["BorderSizePixel"] = 0;
G2L["2b"]["TextSize"] = 14;
G2L["2b"]["TextScaled"] = true;
G2L["2b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["2b"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["2b"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2b"]["BackgroundTransparency"] = 1;
G2L["2b"]["Size"] = UDim2.new(0, 260, 0, 43);
G2L["2b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2b"]["Text"] = [[Sander UI]];
G2L["2b"]["Name"] = [[LogoTEXT]];
G2L["2b"]["Position"] = UDim2.new(0.045, 0, 0.16, 0);

G2L["2c"] = Instance.new("UIStroke", G2L["2b"]);
G2L["2c"]["Color"] = Color3.fromRGB(44, 44, 44);

G2L["2d"] = Instance.new("Frame", G2L["2a"]);
G2L["2d"]["BorderSizePixel"] = 0;
G2L["2d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["2d"]["Size"] = UDim2.new(0, 400, 0, 75);
G2L["2d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2d"]["Name"] = [[TopBAR]];
G2L["2d"]["BackgroundTransparency"] = 1;

G2L["2e"] = Instance.new("TextButton", G2L["2a"]);
G2L["2e"]["BorderSizePixel"] = 0;
G2L["2e"]["TextSize"] = 14;
G2L["2e"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["2e"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["2e"]["BackgroundTransparency"] = 1;
G2L["2e"]["Size"] = UDim2.new(0, 22, 0, 20);
G2L["2e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2e"]["Text"] = [[]];
G2L["2e"]["Name"] = [[HomeBTN]];
G2L["2e"]["Position"] = UDim2.new(0.765, 6, 0.22648, 0);

G2L["2f"] = Instance.new("TextButton", G2L["2a"]);
G2L["2f"]["BorderSizePixel"] = 0;
G2L["2f"]["TextSize"] = 14;
G2L["2f"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["2f"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["2f"]["BackgroundTransparency"] = 1;
G2L["2f"]["Size"] = UDim2.new(0, 22, 0, 20);
G2L["2f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2f"]["Text"] = [[]];
G2L["2f"]["Name"] = [[CloseBTN]];
G2L["2f"]["Position"] = UDim2.new(0.89, 6, 0.22648, 0);

G2L["30"] = Instance.new("TextButton", G2L["2a"]);
G2L["30"]["BorderSizePixel"] = 0;
G2L["30"]["TextSize"] = 14;
G2L["30"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["30"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["30"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["30"]["BackgroundTransparency"] = 1;
G2L["30"]["Size"] = UDim2.new(0, 22, 0, 20);
G2L["30"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["30"]["Text"] = [[]];
G2L["30"]["Name"] = [[SettingsBTN]];
G2L["30"]["Position"] = UDim2.new(0.7, 6, 0.22648, 0);

G2L["31"] = Instance.new("TextButton", G2L["2a"]);
G2L["31"]["BorderSizePixel"] = 0;
G2L["31"]["TextSize"] = 14;
G2L["31"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["31"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["31"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["31"]["BackgroundTransparency"] = 1;
G2L["31"]["Size"] = UDim2.new(0, 22, 0, 20);
G2L["31"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["31"]["Text"] = [[]];
G2L["31"]["Name"] = [[MinimizeBTN]];
G2L["31"]["Position"] = UDim2.new(0.8275, 6, 0.22648, 0);


-- HİLE KODLARININ ÇALIŞMASI İÇİN OLUŞTURULAN LOKAL FONKSİYON
local function C_2()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()

    -- 🔴 NOT: AŞAĞIDAKİ LİNKİ KENDİ GITHUB/PASTEBIN RAW LİNKİNİZLE DEĞİŞTİRİN
    local SanderUI = loadstring(game:HttpGet("BURAYA_KOPYALADIGINIZ_RAW_LINKI_YAPISTIRIN"))()

    local Window = SanderUI:CreateWindow({
        Name = "ENI & LO | Master Suite",
        Theme = SanderUI.Themes.Dark,
        Logo = "rbxassetid://10618928818" 
    })

    local BadgePage = Window:CreateTab({ Name = "🏅 Badge" })
    local SlapFarmPage = Window:CreateTab({ Name = "🏆 Slap & Farm" })
    local FlyPage = Window:CreateTab({ Name = "✈️ Uçuş (Fly)" })
    local MapPage = Window:CreateTab({ Name = "🗺️ Adalar & TP" })
    local SpamPage = Window:CreateTab({ Name = "🔥 1000x E Spam" })
    local SecurityPage = Window:CreateTab({ Name = "🛡️ Güvenlik & Anti" })
    local InspectorPage = Window:CreateTab({ Name = "🔍 Part Analizci" })


    local bobStatusLabel = nil
    local InfoLabel = nil
    local BobFarmActive = false
    local AdvancedSlapFarmActive = false
    local ManualSpamActive = false
    local InspectorActive = false
    local AutoOrbitBadgeActive = false
    local AutoSlappleActive = false
    local AntiSlapActive = false
    local AntiAdminActive = false
    local AntiVoidActive = false
    local TycoonBadgeActive = false
    local FlyActive = false
    local FlySpeed = 50
    local FlyConnection = nil
    local CurrentState = "CHECK_GLOVE"
    local GloveCache = {}
    local SavedPartPath = ""

    local function StartFly()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid then return end
    
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.Parent = hrp
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
    
        local bg = Instance.new("BodyGyro")
        bg.Name = "FlyGyro"
        bg.Parent = hrp
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.CFrame = hrp.CFrame
    
        FlyConnection = RunService.RenderStepped:Connect(function()
            if not FlyActive then return end
            local camera = Workspace.CurrentCamera
            local moveDirection = Vector3.new(0, 0, 0)
    
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
    
            bv.Velocity = moveDirection * FlySpeed
            bg.CFrame = camera.CFrame
            humanoid.PlatformStand = true
        end)
    end
    
    local function StopFly()
        if FlyConnection then FlyConnection:Disconnect(); FlyConnection = nil end
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if hrp then
                if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
                if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
            end
            if humanoid then humanoid.PlatformStand = false end
        end
    end
    
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end)
    
    task.spawn(function()
        while true do
            task.wait(0.05)
            if AntiSlapActive then
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local hrp = char.HumanoidRootPart
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum and (hum.PlatformStand or hum.Sit) and not FlyActive then
                            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                            hum.PlatformStand = false
                            hum:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end
                end)
            end
        end
    end)
    
    task.spawn(function()
        while true do
            task.wait(0.2)
            if AntiVoidActive then
                pcall(function()
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp and hrp.Position.Y < -50 then
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        hrp.CFrame = CFrame.new(0, 50, 0)
                    end
                end)
            end
        end
    end)
    
    local function ScanGloves()
        table.clear(GloveCache)
        local lobby = Workspace:FindFirstChild("Lobby")
        if lobby then
            for _, item in ipairs(lobby:GetChildren()) do
                local cd = item:FindFirstChildWhichIsA("ClickDetector", true)
                if cd then GloveCache[string.lower(item.Name)] = { Part = item, ClickDetector = cd } end
            end
		end
    end
    
    local function IsReplicaEquipped()
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        if leaderstats then
            local gloveStat = leaderstats:FindFirstChild("Glove")
            if gloveStat and gloveStat:IsA("StringValue") then
                if string.lower(gloveStat.Value) == "replica" then return true end
            end
        end
        return false
    end
    
    local function EquipGlove(gloveName)
        if IsReplicaEquipped() then return true end
        local targetName = string.lower(gloveName)
        local gloveData = GloveCache[targetName]
        if not gloveData or not gloveData.Part then
            ScanGloves()
            gloveData = GloveCache[targetName]
            if not gloveData then return false end
        end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.Anchored = true
        local targetPivot = gloveData.Part:IsA("Model") and gloveData.Part:GetPivot() or gloveData.Part.CFrame
        hrp.CFrame = targetPivot + Vector3.new(0, 3, 0)
        task.wait(0.05)
        if gloveData.ClickDetector then fireclickdetector(gloveData.ClickDetector) end
        task.wait(0.05)
        hrp.Anchored = false
        return IsReplicaEquipped()
    end
    
    local function WalkFromSpawnToPortal()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local lobby = Workspace:FindFirstChild("Lobby")
        local redPortal = lobby and lobby:FindFirstChild("Teleport1")
        if not hrp or not humanoid or not redPortal then return false end
        hrp.Anchored = false
        local timeout = tick() + 15 
        while tick() < timeout and BobFarmActive do
            local currentCharacter = LocalPlayer.Character
            if not currentCharacter or not currentCharacter:FindFirstChild("HumanoidRootPart") then break end
            local currentHrp = currentCharacter.HumanoidRootPart
            local currentHumanoid = currentCharacter:FindFirstChildOfClass("Humanoid")
            local dist = (currentHrp.Position - redPortal.Position).Magnitude
            if dist < 3 then break end
            if currentHumanoid then currentHumanoid:MoveTo(redPortal.Position) end
            task.wait(0.1)
        end
        if firetouchinterest then
            firetouchinterest(hrp, redPortal, 0)
            task.wait(0.01)
            firetouchinterest(hrp, redPortal, 1)
        end
        task.wait(0.4) 
        return true
    end
    
    local function EnterPortalAndGoTo(destinationCFrame)
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local lobby = Workspace:FindFirstChild("Lobby")
        local redPortal = lobby and lobby:FindFirstChild("Teleport1")
        if not hrp or not humanoid or not redPortal then return false end
        hrp.Anchored = false
        local timeout = tick() + 10
        while tick() < timeout do
            local currChar = LocalPlayer.Character
            if not currChar or not currChar:FindFirstChild("HumanoidRootPart") then break end
            local curHrp = currChar.HumanoidRootPart
            local curHum = currChar:FindFirstChildOfClass("Humanoid")
            if (curHrp.Position - redPortal.Position).Magnitude < 3 then break end
            if curHum then curHum:MoveTo(redPortal.Position) end
            task.wait(0.1)
        end
        if firetouchinterest then
            firetouchinterest(hrp, redPortal, 0)
            task.wait(0.01)
            firetouchinterest(hrp, redPortal, 1)
        end
        task.wait(0.6)
        local newChar = LocalPlayer.Character
        local newHrp = newChar and newChar:FindFirstChild("HumanoidRootPart")
        if newHrp then
            newHrp.CFrame = destinationCFrame + Vector3.new(0, 3, 0)
            return true
        end
        return false
    end
    
    local function TPToTycoonPlateWithPortal()
        local plate = Workspace:FindFirstChild("Arena") and Workspace.Arena:FindFirstChild("Plate")
        if plate then
            EnterPortalAndGoTo(plate.CFrame)
        end
    end
    
    task.spawn(function()
        while true do
            task.wait()
            if AutoSlappleActive then
                pcall(function()
                    local slapplesFolder = Workspace:FindFirstChild("Arena") 
                        and Workspace.Arena:FindFirstChild("island5") 
                        and Workspace.Arena.island5:FindFirstChild("Slapples")
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if slapplesFolder and hrp and firetouchinterest then
                        for _, slappleModel in ipairs(slapplesFolder:GetChildren()) do
                            local glovePart = slappleModel:FindFirstChild("Glove")
                            if glovePart and glovePart:IsA("BasePart") then
                                firetouchinterest(hrp, glovePart, 0)
                                firetouchinterest(hrp, glovePart, 1)
                            end
                        end
                    end
                end)
            end
        end
    end)
    
    task.spawn(function()
        local threatStartTime = 0
        local isThreatDetected = false
        while true do
            task.wait(0.2)
            if AutoOrbitBadgeActive then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bobFound = false
                    for _, obj in ipairs(Workspace:GetChildren()) do
                        if obj.Name == "Bob" and obj:FindFirstChild("HumanoidRootPart") then
                            if (hrp.Position - obj.HumanoidRootPart.Position).Magnitude < 15 then
                                bobFound = true
                                break
                            end
                        end
                    end
                    if bobFound then
                        if not isThreatDetected then
                            isThreatDetected = true
                            threatStartTime = tick()
                        elseif tick() - threatStartTime >= 2 then
                            hrp.CFrame = CFrame.new(-282.8, -3.6, -0.6)
                            isThreatDetected = false
                            task.wait(1)
                        end
                    else
                        isThreatDetected = false
                    end
                end
            else
                isThreatDetected = false
            end
        end
    end)
    
    local function SpamAbilityGuaranteed(duration)
        local endTime = tick() + duration
        while tick() < endTime and BobFarmActive do
            if VirtualInputManager then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.01)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                task.wait(0.01)
            end
        end
    end
    
    local function FastReset()
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then humanoid.Health = 0 end
        end
        local timeout = tick() + 8
        repeat task.wait(0.1) until (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.Humanoid.Health > 0) or tick() > timeout
        task.wait(0.3)
    end
    
    local function BobBadgeLoop()
        task.spawn(function()
            while true do
                task.wait()
                if not BobFarmActive then
                    CurrentState = "CHECK_GLOVE"
                    if bobStatusLabel then bobStatusLabel:SetText("Durum: Beklemede") end
                    task.wait(0.5)
                    continue
                end
                pcall(function()
                    if CurrentState == "CHECK_GLOVE" then
                        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
                        local gloveStat = leaderstats and leaderstats:FindFirstChild("Glove")
                        if gloveStat and string.lower(gloveStat.Value) ~= "replica" then
                            if bobStatusLabel then bobStatusLabel:SetText("Durum: Replica Gerekli") end
                        else
                            if bobStatusLabel then bobStatusLabel:SetText("Durum: Çalışıyor...") end
                        end
    
                        local success = EquipGlove("Replica")
                        if success then CurrentState = "WALK_PORTAL" else task.wait(0.5) end
                    elseif CurrentState == "WALK_PORTAL" then
                        WalkFromSpawnToPortal()
                        local char = LocalPlayer.Character
                        if char and char.PrimaryPart and char.PrimaryPart.Position.Y < 100 then
                            CurrentState = "SPAM"
                        else
                            task.wait(0.5)
                        end
                    elseif CurrentState == "SPAM" then
                        SpamAbilityGuaranteed(0.6)
                        CurrentState = "RESET"
                    elseif CurrentState == "RESET" then
                        FastReset()
                        if IsReplicaEquipped() then CurrentState = "WALK_PORTAL" else CurrentState = "CHECK_GLOVE" end
                    end
                end)
            end
        end)
    end
    
    task.spawn(function()
        while true do
            task.wait(1)
            if TycoonBadgeActive then
                local plate = Workspace:FindFirstChild("Arena") and Workspace.Arena:FindFirstChild("Plate")
                if plate then
                    EnterPortalAndGoTo(plate.CFrame)
                    local startTime = tick()
                    while tick() - startTime < 600 and TycoonBadgeActive do
                        task.wait(1)
                    end
                    TycoonBadgeActive = false
                end
            end
        end
    end)
    
    task.spawn(function()
        while true do
            if ManualSpamActive then
                if VirtualInputManager then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait(0.0001)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    task.wait(0.0001)
                else
                    task.wait(0.2)
                end
            else
                task.wait(0.2)
            end
        end
    end)
    
    -- ⚡ GÖRÜNMEZ / TP'SİZ SİLESS SLAP FARM
    task.spawn(function()
        while true do
            task.wait(0.1)
            if AdvancedSlapFarmActive then
                pcall(function()
                    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") and (string.lower(remote.Name) == "slap" or string.lower(remote.Name) == "hit" or string.lower(remote.Name) == "baux") then
                            for _, p in ipairs(Players:GetPlayers()) do
                                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                    remote:FireServer(p.Character.HumanoidRootPart)
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if not InspectorActive then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local target = Mouse.Target
            if target then
                SavedPartPath = target:GetFullName()
                if InfoLabel then InfoLabel:SetText("Yol: " .. SavedPartPath) end
                if setclipboard then pcall(function() setclipboard(SavedPartPath) end) end
            end
        end
    end)
    
    -- 🏅 Badge Page
    bobStatusLabel = BadgePage:CreateLabel({ Text = "Durum: Beklemede" })
    BadgePage:CreateMiniToggle({
        Name = "Auto Orbit Badge (Bob İçin)",
        Callback = function(v) AutoOrbitBadgeActive = v end
    })
    BadgePage:CreateMiniToggle({
        Name = "Auto Bob Badge",
        Callback = function(v)
            BobFarmActive = v 
            if v then 
                CurrentState = "CHECK_GLOVE" 
            else 
                bobStatusLabel:SetText("Durum: Beklemede") 
            end 
        end
    })
    BadgePage:CreateMiniToggle({
        Name = "Tycoon Badge (600s Bekle)",
        Callback = function(v) TycoonBadgeActive = v end
    })
    BadgePage:CreateButton({
        Name = "Retro Badge TP (Bitiş Kapısı)",
        Callback = function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(-27776.10, 169.13, 4834.74) + Vector3.new(0, 3, 0) end
        end
    })
    
    -- 🏆 Slap & Farm Page
    SlapFarmPage:CreateMiniToggle({
        Name = "Oto Slap Farm (Silent & TP'siz)",
        Callback = function(v) AdvancedSlapFarmActive = v end
    })
    SlapFarmPage:CreateMiniToggle({
        Name = "Çok Hızlı Oto Slapple Toplayıcı",
        Callback = function(v) AutoSlappleActive = v end
    })
    
    -- ✈️ Uçuş Page
    FlyPage:CreateMiniToggle({
        Name = "Uçuşu Başlat (Fly)",
        Callback = function(v)
            FlyActive = v
            if v then StartFly() else StopFly() end
        end
    })
    
    -- 🗺️ Adalar & TP Page
    local Islands = {
        ["Brasil Portal"] = CFrame.new(-1123.1, 312.1, -3.6),
        ["Slapple Adası"] = CFrame.new(-403.3, 48.7, -17.2),
        ["Kale Adası"] = CFrame.new(268.0, 33.7, 202.6),
        ["Moai Adası"] = CFrame.new(210.5, -15.7, -8.7),
        ["Sağ Ada"] = CFrame.new(-7.2, -5.1, -205.0),
        ["Sol Ada"] = CFrame.new(3.1, -5.1, 207.0),
        ["Default Adası"] = CFrame.new(133.5, 360.0, 1.3),
        ["Bulut Adası"] = CFrame.new(-125.322, -4.556, 122.432),
    }
    for name, cf in pairs(Islands) do
        MapPage:CreateButton({
            Name = "TP -> " .. name,
            Callback = function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = cf + Vector3.new(0, 3, 0) end
            end
        })
    end
    MapPage:CreateButton({
        Name = "Tycoon Plate'e Portaldan Git",
        Callback = function() TPToTycoonPlateWithPortal() end
    })
    
    -- 🔥 Spam Page
    SpamPage:CreateMiniToggle({
        Name = "1000x E Spam",
        Callback = function(v) ManualSpamActive = v end
    })
    
    -- 🛡️ Güvenlik Page
    SecurityPage:CreateMiniToggle({
        Name = "Anti-Admin Algılayıcı",
        Callback = function(v) AntiAdminActive = v end
    })
    SecurityPage:CreateMiniToggle({
        Name = "Anti-Slap Yeme",
        Callback = function(v) AntiSlapActive = v end
    })
    SecurityPage:CreateMiniToggle({
        Name = "Anti-AFK Koruması",
        Callback = function(v) end
    })
    SecurityPage:CreateMiniToggle({
        Name = "Anti-Void (Haritadan Düşme)",
        Callback = function(v) AntiVoidActive = v end
    })
    
    -- 🔍 Inspector Page
    InfoLabel = InspectorPage:CreateLabel({ Text = "Bilgi: Henüz bir parta tıklanmadı." })
    InspectorPage:CreateMiniToggle({
        Name = "Tıklanan Partı Kaydet",
        Callback = function(v) InspectorActive = v end
    })
    
    ScanGloves()
    BobBadgeLoop()
    SanderUI:Notify({
        Title = "ENI & LO Yüklendi!",
        Content = "SanderUI v6.3 entegrasyonlu Master Suite başarıyla aktif edildi.",
        Duration = 5
    })
end

task.spawn(C_2)
