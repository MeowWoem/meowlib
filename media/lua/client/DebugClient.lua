require "MeowCore";

local UIPanel = MeowCore:require("Client/UserInterface/UIPanel");

local elm = UIPanel:new(500, 250, 500, 500);
elm:initialise();
elm:addToUIManager();
elm:setVisible(true);
