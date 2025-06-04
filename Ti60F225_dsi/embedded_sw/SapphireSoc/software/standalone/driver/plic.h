///////////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 2025 SaxonSoc contributors
//  SPDX license identifier: MIT
//  Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
///////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
*
* @file plic.h
*
* @brief Header file containing definitions and functions for PLIC operations.
*
* Functions:
* - plic_set_priority: Sets the priority of an interrupt gateway in the PLIC.
* - plic_get_priority: Retrieves the priority of an interrupt gateway from the PLIC.
* - plic_set_enable: Enables or disables an interrupt gateway for a target in the PLIC.
* - plic_set_threshold: Sets the threshold for a target in the PLIC.
* - plic_get_threshold: Retrieves the threshold for a target from the PLIC.
* - plic_claim: Claims an interrupt for a target from the PLIC.
* - plic_release: Releases a claimed interrupt for a target from the PLIC.
*
******************************************************************************/
#pragma once

#include "type.h"
#include "io.h"

#define PLIC_PRIORITY_BASE      0x0000 /*Base address for the priority registers. */
#define PLIC_PENDING_BASE       0x1000 /*Base address for the pending registers.*/
#define PLIC_ENABLE_BASE        0x2000
#define PLIC_THRESHOLD_BASE     0x200000
#define PLIC_CLAIM_BASE         0x200004
#define PLIC_ENABLE_PER_HART    0x80
#define PLIC_CONTEXT_PER_HART   0x1000

/*******************************************************************************
*
* @brief   This function sets the priority of a specific interrupt gateway in the PLIC.
*
* @param   plic is the base address of the PLIC registers.
* @param   gateway is the ID of the interrupt gateway for which the priority
*          is being set.
* @param   priority is the priority value to be set for the specified interrupt
*          gateway.
*
* @return  None.
*
* @note    The function calculates the address offset for the priority register
*          associated with the specified interrupt gateway. It then writes the
*          specified priority value to the calculated address, effectively
*          setting the priority for the specified interrupt gateway in the PLIC.
*
******************************************************************************/
    static void plic_set_priority(u32 plic, u32 gateway, u32 priority){
        write_u32(priority, plic + PLIC_PRIORITY_BASE + gateway*4);
    }

/*******************************************************************************
*
* @brief   This function retrieves the priority of a specific interrupt gateway from the PLIC.
*
* @param   plic is the base address of the PLIC registers.
* @param   gateway is the ID of the interrupt gateway for which the priority
*          is being retrieved.
*
* @return  The priority value of the specified interrupt gateway as a 32-bit
*          unsigned integer.
*
* @note    The function calculates the address offset for the priority register
*          associated with the specified interrupt gateway. It then reads the
*          32-bit unsigned integer value from the calculated address, effectively
*          retrieving the priority for the specified interrupt gateway in the PLIC.
*
******************************************************************************/
    static u32 plic_get_priority(u32 plic, u32 gateway){
        return read_u32(plic + PLIC_PRIORITY_BASE + gateway*4);
    }
    
/*******************************************************************************
*
* @brief   This function enables or disables a specific interrupt gateway for a target.
*
* @param   plic is the base address of the PLIC registers.
* @param   target is the ID of the target (hardware thread or hart) for which
*          the interrupt is being enabled or disabled.
* @param   gateway is the ID of the interrupt gateway being enabled or disabled.
* @param   enable is a boolean value indicating whether to enable (true) or disable
*          (false) the interrupt.
*
* @return  None.
*
* @note    The function calculates the address of the word in the enable register
*          associated with the specified target and gateway. It then calculates
*          the bit mask for the specific interrupt gateway within the word. If
*          enable is true, it sets the bit corresponding to the interrupt gateway
*          in the register. If enable is false, it clears the bit corresponding
*          to the interrupt gateway. Finally, it writes the modified value back
*          to the enable register.
*
******************************************************************************/

    static void plic_set_enable(u32 plic, u32 target,u32 gateway, u32 enable){
        u32 word = plic + PLIC_ENABLE_BASE + target * PLIC_ENABLE_PER_HART + (gateway / 32 * 4);
        u32 mask = 1 << (gateway % 32);
        if (enable)
            write_u32(read_u32(word) | mask, word);
        else
            write_u32(read_u32(word) & ~mask, word);
    }
    
/*******************************************************************************
*
* @brief  This function sets the threshold for a specific target in the PLIC.
*
* @param   plic is the base address of the PLIC registers.
* @param   target is the ID of the target (hardware thread or hart) for which
*          the threshold is being set.
* @param   threshold is the threshold value to be set for the specified target.
*
* @return  None.
*
* @note    The function calculates the address of the threshold register associated
*          with the specified target. It then writes the specified threshold value
*          to the calculated address, effectively setting the threshold for the
*          specified target in the PLIC.
*
******************************************************************************/   
    static void plic_set_threshold(u32 plic, u32 target, u32 threshold){
        write_u32(threshold, plic + PLIC_THRESHOLD_BASE + target*PLIC_CONTEXT_PER_HART);
    }

/*******************************************************************************
*
* @brief   This function retrieves the threshold for a specific target from the PLIC.
*
* @param   plic is the base address of the PLIC registers.
* @param   target is the ID of the target (hardware thread or hart) for which
*          the threshold is being retrieved.
*
* @return  The threshold value of the specified target as a 32-bit unsigned integer.
*
* @note    The function calculates the address of the threshold register associated
*          with the specified target. It then reads the 32-bit unsigned integer value
*          from the calculated address, effectively retrieving the threshold for the
*          specified target in the PLIC.
*
******************************************************************************/
    static u32 plic_get_threshold(u32 plic, u32 target){
        return read_u32(plic + PLIC_THRESHOLD_BASE + target*PLIC_CONTEXT_PER_HART);
    }
    
/*******************************************************************************
*
* @brief   This function claims an interrupt for a specific target from the PLIC.
*
* @param   plic is the base address of the PLIC registers.
* @param   target is the ID of the target (hardware thread or hart) for which
*          the interrupt is being claimed.
*
* @return  The ID of the claimed interrupt as a 32-bit unsigned integer.
*
* @note    The function calculates the address of the claim register associated
*          with the specified target. It then reads the 32-bit unsigned integer
*          value from the calculated address, effectively claiming an interrupt
*          for the specified target in the PLIC.
*
******************************************************************************/
    static u32 plic_claim(u32 plic, u32 target){
        return read_u32(plic + PLIC_CLAIM_BASE + target*PLIC_CONTEXT_PER_HART);
    }
    
/*******************************************************************************
*
* @brief   This function releases a claimed interrupt for a specific target in the PLIC.
*
* @param   plic is the base address of the PLIC registers.
* @param   target is the ID of the target (hardware thread or hart) for which
*          the interrupt is being released.
* @param   gateway is the ID of the interrupt gateway for which the interrupt
*          is being released.
*
* @return  None.
*
* @note    The function calculates the address of the claim register associated
*          with the specified target. It then writes the ID of the interrupt gateway
*          to the calculated address, effectively releasing the claimed interrupt
*          for the specified target in the PLIC.
*
******************************************************************************/
    static void plic_release(u32 plic, u32 target, u32 gateway){
        write_u32(gateway,plic + PLIC_CLAIM_BASE + target*PLIC_CONTEXT_PER_HART);
    }



