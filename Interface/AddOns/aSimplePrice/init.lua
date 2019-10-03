local merchantOpen = false

function ShowPrice(tooltip)
  if not merchantOpen then
    local _, link = tooltip:GetItem()
    if not link then return end

    local _, _, _, _, _, _, _, stack, _, _, price = GetItemInfo(link)
    if not price or price <= 0 then return end

    local count = 1
    if (stack > 1) then
      local focus = GetMouseFocus()
      local describe = focus:GetName() and (focus:GetName() .. "Count")

      count = focus.count or (focus.Count and focus.Count:GetText()) or (focus.Quantity and focus.Quantity:GetText()) or (describe and _G[describe] and _G[describe]:GetText())
      count = tonumber(count) or 1
    end

    SetTooltipMoney(tooltip, count * price, "STATIC")
  end
end

GameTooltip:HookScript("OnTooltipSetItem", ShowPrice)
ItemRefTooltip:HookScript("OnTooltipSetItem", ShowPrice)

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent ("MERCHANT_SHOW")
EventFrame:RegisterEvent ("MERCHANT_CLOSED")

EventFrame:SetScript("OnEvent", function(self, event, ...)
	if (event == "MERCHANT_SHOW") then
    merchantOpen = true
	elseif (event == "MERCHANT_CLOSED") then
    merchantOpen = false
  end
end)
