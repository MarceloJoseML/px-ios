//
//  MPFlowBuilder.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 1/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import Foundation
import UIKit

public class MPFlowBuilder : NSObject {
    
    @available(*, deprecated=2.0, message="Use startCheckoutViewController instead")
    public class func startVaultViewController(amount: Double, supportedPaymentTypes: Set<PaymentTypeId>?, callback: (paymentMethod: PaymentMethod, tokenId: String?, issuer: Issuer?, installments: Int) -> Void) -> VaultViewController {
        
        return VaultViewController(amount: amount, supportedPaymentTypes: supportedPaymentTypes, callback: callback)
        
    }

    
    public class func startCheckoutViewController(preference: CheckoutPreference, callback: (Payment) -> Void) -> UINavigationController {
            return MPFlowBuilder.startPaymentVaultInCheckout(preference.getAmount(), currencyId: preference.getCurrencyId(), purchaseTitle: preference.getTitle(), excludedPaymentTypes: preference.getExcludedPaymentTypes(), excludedPaymentMethods: preference.getExcludedPaymentMethods(), defaultPaymentMethodId: preference.getDefaultPaymentMethodId(), callback: { (paymentMethod, cardToken, issuer, installments) -> Void in
                
                let checkoutVC = CheckoutViewController(preference: preference, callback: { (payment : Payment) -> Void in
                    callback(payment)
                })
                checkoutVC.paymentMethod = paymentMethod
                checkoutVC.installments = installments
                checkoutVC.issuer = issuer
                checkoutVC.cardToken = cardToken
                checkoutVC.callback = {(payment: Payment) -> Void in
                    checkoutVC.dismissViewControllerAnimated(true, completion: { () -> Void in
                        callback(payment)
                    })
                }

                MPFlowController.push(checkoutVC)
            })
    }
    
    public class func startPaymentVaultViewController(amount: Double, currencyId: String, purchaseTitle : String, excludedPaymentTypes: Set<PaymentTypeId>?, excludedPaymentMethods : [String]?, defaultPaymentMethodId : String?,installments : Int = 1, defaultInstallments : Int = 1, callback: (paymentMethod: PaymentMethod, cardToken: CardToken?, issuer: Issuer?, installments: Int) -> Void) -> UINavigationController {
        
        let paymentVault = PaymentVaultViewController(amount: amount, currencyId: currencyId, purchaseTitle: purchaseTitle, excludedPaymentTypes: excludedPaymentTypes, excludedPaymentMethods: excludedPaymentMethods, defaultPaymentMethodId: defaultPaymentMethodId, installments: installments, defaultInstallments: defaultInstallments, callback: callback)
        
        paymentVault.callback = {(paymentMethod: PaymentMethod, cardToken: CardToken?, issuer: Issuer?, installments: Int) -> Void in
            paymentVault.dismissViewControllerAnimated(true, completion: { () -> Void in
                callback(paymentMethod: paymentMethod, cardToken: cardToken, issuer: issuer, installments: installments)
            })
        }
        paymentVault.modalTransitionStyle = .CrossDissolve
        return MPFlowController.createNavigationControllerWith(paymentVault)
    }
    
    internal class func startPaymentVaultInCheckout(amount: Double, currencyId: String, purchaseTitle : String, excludedPaymentTypes: Set<PaymentTypeId>?, excludedPaymentMethods : [String]?, defaultPaymentMethodId : String?,installments : Int = 1, defaultInstallments : Int = 1, callback: (paymentMethod: PaymentMethod, cardToken: CardToken?, issuer: Issuer?, installments: Int) -> Void) -> UINavigationController {
        
        let paymentVault = PaymentVaultViewController(amount: amount, currencyId: currencyId, purchaseTitle: purchaseTitle, excludedPaymentTypes: excludedPaymentTypes, excludedPaymentMethods: excludedPaymentMethods, defaultPaymentMethodId: defaultPaymentMethodId, installments: installments, defaultInstallments: defaultInstallments, callback: callback)
        paymentVault.modalTransitionStyle = .CrossDissolve
        
        return MPFlowController.createNavigationControllerWith(paymentVault)
    }
    /*
    
    self.showViewController( MPStepBuilder.startCreditCardForm(nil , amount: 10000, callback: { (paymentMethod, token, issuer, installment) -> Void in
    //      print(paymentMethod.name)
    
    self.showViewController(MPStepBuilder.startPayerCostForm(paymentMethod, issuer: issuer, cardToken: token!, amount: 1550, minInstallments: 1, callback: { (installment) -> Void in
    print("OK!")
    }))
    }))
    */

    
    public class func startCardFlow(paymentType : PaymentType? , amount: Double, callback: (paymentMethod: PaymentMethod, cardToken: CardToken? ,  issuer: Issuer?, payerCost: PayerCost?) -> Void) -> UINavigationController {
        
        
        let cardVC = MPStepBuilder.startCreditCardForm(nil , amount: amount, callback: { (paymentMethod, token, issuer, installment) -> Void in
            if ((installment == nil)||(installment?.payerCosts == nil)||(installment?.payerCosts.count < 2)){
                if ((installment != nil) && (installment!.payerCosts != nil) && (installment!.payerCosts.count > 0) ){
                    callback(paymentMethod: paymentMethod, cardToken: token, issuer: issuer, payerCost: installment?.payerCosts[0])
                }else{
                    callback(paymentMethod: paymentMethod, cardToken: token, issuer: issuer, payerCost:nil)
                }
                
                MPFlowController.sharedInstance.navigationController?.dismissViewControllerAnimated(false, completion: { () -> Void in
                    print("Ya esta!")
                })
            }else{
            
            MPFlowController.sharedInstance.navigationController?.pushViewController(MPStepBuilder.startPayerCostForm(paymentMethod, issuer: issuer, cardToken: token!, amount: amount, minInstallments: 1, callback: { (payerCost) -> Void in
                print("OK!")
                callback(paymentMethod: paymentMethod, cardToken: token, issuer: issuer, payerCost: payerCost)
            }), animated: false)
            
               // MPFlowController.push()
            }
        })
        
        cardVC.modalTransitionStyle = .CrossDissolve
        
        
        
        return MPFlowController.createNavigationControllerWith(cardVC)
        
        
    }

}
