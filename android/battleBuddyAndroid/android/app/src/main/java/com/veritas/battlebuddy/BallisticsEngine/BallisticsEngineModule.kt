package com.veritas.battlebuddy.BallisticsEngine

import com.battlebuddy.ballisticsengine.*
import com.facebook.react.bridge.*

class Ammo(val ammo: ReadableMap): CalculableAmmo {
    override val resolvedPenetration: Double
        get() = ammo.getDouble("penetration")
    override val resolvedDamage: Double
        get() = ammo.getDouble("totalDamage")
    override val resolvedArmorDamage: Double
        get() = ammo.getDouble("totalArmorDamage")
    override val resolvedFragmentationChance: Double
        get() = ammo.getDouble("fragmentationChance")
    override val didFragment: Boolean
        get() = ammo.getBoolean("didFrag")
}

class Armor (val armor: ReadableMap) : CalculableArmor {
    override val resolvedArmorClass: Int
        get() = armor.getInt("armorClass")
    override val resolvedCurrentDurability: Double
        get() = armor.getDouble("currentDurability")
    override val resolvedMaxDurability: Double
        get() = armor.getDouble("durability")
    override val resolvedDestructibility: Double
        get() = armor.getDouble("destructibility")
    override val resolvedProtectionZones: Array<BodyZoneType>
        get() = arrayOf()
}


class BallisticsEngineModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return "BallisticsEngine"
    }

    @ReactMethod
    fun penetrationChance(
        armor: ReadableMap,
        ammo: ReadableMap,
        callback: Callback
    ) {
        val result = PenetrationCalculator().penetrationChance(Armor(armor), Ammo(ammo))
        callback(result)
    }

    @ReactMethod
    fun damageCalculator (person: ReadableMap, ammo: ReadableMap, bodyZone: String, callback: Callback) {
        val healthMap = mapOf(
            Pair(BodyZoneType.HEAD, person.getDouble("head")),
            Pair(BodyZoneType.THORAX, person.getDouble("thorax")),
            Pair(BodyZoneType.RIGHTARM, person.getDouble("rightArm")),
            Pair(BodyZoneType.STOMACH, person.getDouble("stomach")),
            Pair(BodyZoneType.LEFTARM, person.getDouble("leftArm")),
            Pair(BodyZoneType.RIGHTLEG, person.getDouble("rightLeg")),
            Pair(BodyZoneType.LEFTLEG, person.getDouble("leftLeg"))
        )

        val impactedBodyZoneType = BodyZoneType.valueOf(bodyZone)
        val newPerson = Person(healthMap)
        val result = HealthCalculator().processImpact(newPerson, impactedBodyZoneType, Ammo(ammo));
        val resultMap: WritableMap = Arguments.createMap()

        resultMap.putBoolean("isAlive", result.isAlive)
        resultMap.putDouble("head", result.head.currentHp)
        resultMap.putDouble("leftArm", result.leftArm.currentHp)
        resultMap.putDouble("thorax", result.thorax.currentHp)
        resultMap.putDouble("rightArm", result.rightArm.currentHp)
        resultMap.putDouble("stomach", result.stomach.currentHp)
        resultMap.putDouble("leftLeg", result.leftLeg.currentHp)
        resultMap.putDouble("rightLeg", result.rightLeg.currentHp)
        resultMap.putDouble("totalHp", result.totalCurrentHp)

        callback(resultMap)
    }
}