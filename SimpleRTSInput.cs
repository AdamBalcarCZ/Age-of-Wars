using UnityEngine;

public class SimpleRTSInput : MonoBehaviour
{
    void Update()
    {
        if (Input.GetMouseButtonDown(1))
        {
            MoveUnitsToCursor();
        }
    }

    void MoveUnitsToCursor()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit))
        {
            UnitController[] allUnits = FindObjectsByType<UnitController>(FindObjectsSortMode.None);

            foreach (UnitController unit in allUnits)
            {
                unit.MoveTo(hit.point);
            }
            Debug.Log($"Posílám {allUnits.Length} jednotek na pozici {hit.point}");
        }
    }
}