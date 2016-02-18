--ＥＭキングベアー
--Performapal King Bear
--By: HelixReactor
function c100316002.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100316002.reg)
	c:RegisterEffect(e1)
	--Destroy + tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c100316002.thcon)
	e2:SetTarget(c100316002.thtg)
	e2:SetOperation(c100316002.thop)
	c:RegisterEffect(e2)
	--Indestructable by STs
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c100316002.indescon)
	e3:SetValue(c100316002.indesval)
	c:RegisterEffect(e3)
	--ATK-up
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c100316002.atkcon)
	e4:SetValue(c100316002.atkval)
	c:RegisterEffect(e4)
end
function c100316002.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(100316002,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c100316002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(100316002)~=0
end
function c100316002.thfilter(c)
		local con1 = c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
		local con2 = c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
		return (con1 or con2) and c:IsLevelAbove(7) and c:IsAbleToHand()
end
function c100316002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c100316002.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c100316002.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
			local g=Duel.SelectMatchingCard(tp,c100316002.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
	end
end
function c100316002.indescon(e)
	return e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():IsAttackPos()
end
function c100316002.indesval(e,re,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c100316002.atkcon(e)
	local ph = Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer() == e:GetHandler():GetControler()
		and (ph == PHASE_BATTLE or ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
end
function c100316002.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9f)
end
function c100316002.atkval(e,c)
	return Duel.GetMatchingGroupCount(c100316002.atkfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil)*100
end