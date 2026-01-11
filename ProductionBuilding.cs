using UnityEngine;
using System.Collections;

public class ProductionBuilding : MonoBehaviour
{
    public Transform spawnPoint;

    public void TryProduceUnit(UnitData unitToBuild)
    {
        if (ResourceManager.Instance.CanAfford(unitToBuild.costPolymer, unitToBuild.costEnergy))
        {
            ResourceManager.Instance.SpendResources(unitToBuild.costPolymer, unitToBuild.costEnergy);

            StartCoroutine(ProductionRoutine(unitToBuild));
        }
        else
        {
            Debug.Log("Nedostatek surovin!");
        }
    }

    private IEnumerator ProductionRoutine(UnitData unit)
    {
        Debug.Log($"Trénuji {unit.unitName}... ({unit.trainTime}s)");
        
        yield return new WaitForSeconds(unit.trainTime);

        Instantiate(unit.prefab, spawnPoint.position, spawnPoint.rotation);
        Debug.Log($"{unit.unitName} je připraven do boje!");
    }
}