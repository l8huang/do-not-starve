local ItemSlot = require "widgets/itemslot"

local EquipSlot = Class(ItemSlot, function(self, equipslot, atlas, bgim, owner)
    ItemSlot._ctor(self, atlas, bgim, owner)
    self.owner = owner
    self.equipslot = equipslot
    self.highlight = false

    self.inst:ListenForEvent("newactiveitem", function(owner, data)
        if data.item ~= nil and
            data.item.replica.equippable ~= nil and
            equipslot == data.item.replica.equippable:EquipSlot() then
            self:ScaleTo(1, 1.3, .125)
            self.highlight = true
        elseif self.highlight then
            self.highlight = false
            self:ScaleTo(1.3, 1, .125)
        end
    end, owner)
end)

function EquipSlot:Click()
    self:OnControl(CONTROL_ACCEPT, true)
end

function EquipSlot:OnControl(control, down)
    if down then
        local inventory = self.owner.replica.inventory
        if control == CONTROL_ACCEPT then
            local active_item = inventory:GetActiveItem()
            if active_item ~= nil then
                if active_item.replica.equippable ~= nil and
                    self.equipslot == active_item.replica.equippable:EquipSlot() then
                    if self.tile ~= nil and self.tile.item ~= nil then
                        inventory:SwapEquipWithActiveItem()
                    else
                        inventory:EquipActiveItem()
                    end
                end
            elseif self.tile ~= nil and self.tile.item ~= nil then
                inventory:TakeActiveItemFromEquipSlot(self.equipslot)
            end
            return true
        elseif control == CONTROL_SECONDARY and
            self.tile ~= nil and
            self.tile.item ~= nil then
            inventory:UseItemFromInvTile(self.tile.item)
            return true
        end
    end
end

return EquipSlot